# Release checks

The feature file contains exactly three scenarios, using native ALKiln 5 steps:

1. **State public housing, first repair grievance.** Jordan Rivera asks for a leaking ceiling to be fixed. Check the introductory resource links, initial stage and requested remedy, final instructions, and both PDF downloads.
2. **Federal public housing, rent dispute after an informal meeting.** Taylor Chen disputes a claim of unpaid rent and faces termination. Check the hearing stage and requested account correction, final instructions, and both PDF downloads.
3. **State tenant has a hearing decision.** Check the appeal guidance, deadline warning, MADE link, appeal-stage answer, and absence of the letter-download screen.

Run these through the repository's manual **ALKiln interview tests** GitHub Actions workflow. It uses the official ALKiln sandbox on a temporary server. See the [ALKiln setup guide](https://assemblyline.suffolklitlab.org/docs/components/ALKiln/setup/) and [AI testing guide](https://assemblyline.suffolklitlab.org/docs/automated_quality_checks/ai_testing/). There is no repository-specific runner or browser patch.

These synthetic examples do not decide whether a particular grievance is legally available. They do not cover every housing authority's policy.

## Required manual document and layout checks

These checks preserve coverage formerly supplied by custom steps. Native JSON-answer assertions and successful downloads alone do **not** prove correct PDF content. Record the commit, browser, date, and results when doing these checks before release.

- **Initial PDF:** Use scenario 1's answers. Confirm the letter names Jordan Rivera and the housing authority, includes “I am filing a grievance” and “Repair the ceiling and stop the leak.” It must not claim that a prior informal meeting failed. Check the signature line and all address lines.
- **Edit and regenerate:** From the final screen, select **Edit answers**, then edit **What would fix the problem**. Enter “Stop the leak and repair the water-damaged wall.” Return to the final screen and download again. The PDF must contain the new remedy and must not contain the old remedy. This catches stale attachments that answer-value checks cannot detect.
- **Correct a stage without losing the draft:** Open **Edit answers**, change **Request** to challenge a hearing/appeal decision, and continue to the appeal guidance. Select **Change my request**, return to the initial-grievance choice, and download. Confirm Jordan Rivera, the original problem, and the edited remedy are still present.
- **Federal PDF:** Use scenario 2's answers. Confirm Taylor Chen, “my informal meeting did not solve,” and “Correct my account and withdraw the termination notice.” It must not contain “I am filing a grievance.”
- **Resource links and instructions:** Both instructions PDFs must have working UpToCode and MADE URLs. UpToCode must be an alternative for repairs with no grievance prerequisite. MADE must be for eviction court papers, not a grievance appeal. Check the signature/delivery directions and the state/federal next steps.
- **Mobile layout:** Set the browser viewport to 390 × 844 pixels. Check the introduction, input screens, review, appeal guidance and downloads. Look for readable text, usable buttons, and no horizontal page overflow. Confirm both resource links and all download controls are reachable. Save screenshots of the introduction and downloads.
- **Long narrative:** Use a roughly 2,500-word problem description with 50 numbered incidents and a unique marker at the end of the requested remedy. Download the letter. Confirm all 50 incidents, the complete text, final marker, signature line and address survive. Check each page for clipped lines or text outside the margins. A prior synthetic example flowed across four pages; page count alone is not a pass condition.

## Validation history and limits

The earlier custom suite passed three scenarios / 38 steps before later copy edits. A subsequent run passed the initial/edit/correction and appeal paths but stalled at the federal date field. Direct browser interaction completed that exact federal session and verified both PDFs without runtime or HTTP errors. The plain-language revision re-rendered both letter stages, instructions and the long narrative successfully.

Those are historical checks, not a runtime pass for this migration. The migration to native steps is checked with Cucumber `--dry-run` against the pinned ALKiln package for undefined or ambiguous steps. The official workflow still needs a runtime run, and the manual checks above remain release requirements. Do not describe a dry-run as browser or PDF validation.
