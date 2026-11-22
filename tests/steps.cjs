const path=require('node:path');
const fs=require('node:fs');
const {execFileSync}=require('node:child_process');
const alkiln=process.env.ALKILN_PATH;
const {Then}=require(path.join(alkiln,'node_modules/@cucumber/cucumber'));
const scope=require(path.join(alkiln,'lib/scope'));
// Docassemble now uses div.da-button-set instead of fieldset for these controls.
// Restrict the compatibility change to selectors; keep ALKiln navigation/assertions.
scope.continue_button_selector='.da-field-buttons button[type="submit"].btn-primary';
scope.signature_selector='.da-field-buttons .dasigsave';
// New labels omit aria-checked. Read the associated native input instead.
scope.setCheckbox=async (_scope,{label,answer})=>{
 await label.evaluate((el,want)=>{
  const input=el.control||document.getElementById(el.htmlFor);
  if(!input)throw Error('Checkbox label has no associated input');
  if(input.checked!==want)el.click();
 },String(answer).toLowerCase()==='true');
};
const clean=s=>s.replace(/\s+/g,' ').trim();
Then('the downloaded PDF {string} should contain {string}',async(file,expected)=>{
 const pdf=path.join(scope.paths.scenario,file);
 const text=clean(execFileSync('pdftotext',[pdf,'-'],{encoding:'utf8'}));
 if(!text.includes(clean(expected)))throw Error('Missing PDF text: '+expected);
});
Then('the downloaded PDF {string} should not contain {string}',async(file,unwanted)=>{
 const text=clean(execFileSync('pdftotext',[path.join(scope.paths.scenario,file),'-'],{encoding:'utf8'}));
 if(text.includes(clean(unwanted)))throw Error('Unexpected PDF text: '+unwanted);
});

// Fail promptly on AssemblyLine's custom error screen instead of repeatedly pressing Next.
const examine=scope.examinePageID;
scope.examinePageID=async(...args)=>{
 const result=await examine(...args);
 if(result.id==='custom-error-action')throw Error('Interview runtime error: '+await scope.page.$eval('#daquestion',e=>e.innerText));
 return result;
};
const {When}=require(path.join(alkiln,'node_modules/@cucumber/cucumber'));
When('I follow the review link containing {string}',{timeout:90000},async(text)=>{
 const links=await scope.page.$$('#daquestion a');
 for(const link of links){
  if((await link.evaluate(e=>e.closest('.da-review')?.innerText || e.innerText)).includes(text)){
   await scope.tapElementAndNavigate(scope,{elem:link});return;
  }
 }
 throw Error('No review link containing: '+text);
});

// Retry only read-only page identity queries when Docassemble replaces the DOM.
for (const name of ['get_page_id', 'current_page_id_class_name', 'checkForErrors']) {
 const read = scope[name];
 if (typeof read !== 'function') continue;
 scope[name] = async (...args) => {
  for (let attempt = 0; attempt < 5; attempt++) {
   try { return await read(...args); }
   catch (error) {
    if (!String(error).includes('Execution context was destroyed') || attempt === 4) throw error;
    await new Promise(resolve => setTimeout(resolve, 100));
   }
  }
 };
}

// Review edits submit through AJAX in current Docassemble. ALKiln's native
// navigation promise alone never resolves there. Recognize replaced question
// content too; ALKiln still runs its system/validation/navigation error handlers.
const nativeNavRace=scope.nav_race;
scope.nav_race=(state,options)=>{
 const native=nativeNavRace(state,options);
 const changed=(async()=>{
  const before=await state.page.$eval('#daquestion',e=>e.innerHTML);
  await state.page.waitForFunction(old=>document.querySelector('#daquestion')?.innerHTML!==old,{timeout:state.timeout},before);
 })().catch(error=>{if(!/Execution context was destroyed|same JavaScript world/.test(String(error)))throw error;});
 return {...native,result:Promise.race([native.result,changed])};
};
// Current ALKiln waits for a URL change even when a review event replaces the
// question at the same URL. Preserve validation/system handlers, detect both.
scope.wait_until_continued=async(state,{url='',id='',post_nav_handlers=null})=>{
 const handlers=post_nav_handlers||[state.throw_on_system_error,state.throw_on_invalid_answers,state.throw_on_non_navigation_timeout,state.throw_on_non_navigation_catchall];
 state.throw_if_missing_required_post_nav_handlers(state,{handlers});
 const until=Date.now()+state.timeout;
 while(Date.now()<until){
  let error_data;
  try {
   error_data=await state.checkForErrors(state);
   if(!error_data.ok){for(const handler of handlers)await handler(state,{id,error_data,timed_out:false});return {error_data,navigated:false};}
   const current=await state.examinePageID(state,'none to match');
   if(state.page.url()!==url||(current.id && current.id!=='Unknown id' && current.id!==id)){await new Promise(resolve=>setTimeout(resolve,300));state.navigated=true;return {error_data,navigated:true};}
  } catch(error){if(!String(error).includes('Execution context was destroyed'))throw error;}
  await new Promise(resolve=>setTimeout(resolve,50));
 }
 throw Error('No question or URL change after Continue from '+id);
};
