# Massachusetts public housing grievance

One interview prepares either an initial grievance or a hearing request after an unresolved informal meeting. It serves current Massachusetts public housing tenants raising their own household's problem. It does not automate voucher disputes, housing applications, appeals of hearing decisions, or eviction court answers. Those limitations appear before users provide personal information.

Entry point: `docassemble.MAGrievanceComplaint:data/questions/lt3grievancecomplaint.yml`.

This release candidate consolidates the complaint and hearing-request workflow in one public entry point. Other historical repositories have not been deleted or archived. The integrated version mentioned in interview-backlog #28 was not found in local checkouts, public branches, or the current user's named/default local and development Playgrounds. This branch therefore extends the existing complaint package.

The output has a handwritten signature line. Users review a PDF, download it, print, sign, and deliver it. Nothing is filed or sent automatically.

## Validation

See `tests/SCENARIOS.md` and the three ALKiln scenarios in `data/sources`. `tests/run_alkiln.py` uses credentials from the local user's `.docassemblecli`, without copying secrets into the repository. The runner requires a local docassemble installation, ALKiln, Node, and `pdftotext`.

Run local static readiness with the current DAYamlChecker source. Human legal and publication approval must remain separately documented; a clean static scan is not approval.

## Classification

The current LIST snapshot (taxonomy.legal, retrieved November 22, 2026; feed marked June 16, 2026) has no public-housing-grievance-specific term. `HO-03-02-00-00` is the deepest category common to this tool's supported public housing disputes. `CO-04-00-00-00` adds the administrative request/hearing procedure. Narrower public housing terms such as safety, visitors, or admission would falsely imply a narrower or unsupported scope. Do not tag this as general private tenancy, Section 8, or court litigation.

## Content sources

- [MLRI sample forms](https://www.masslegalhelp.org/housing-apartments-shelter/public-subsidized-housing/sample-letters-forms-and-worksheets)
- [Filing a grievance](https://www.masslegalhelp.org/housing-apartments-shelter/public-subsidized-housing/filing-grievance)
- [Which disputes qualify](https://www.masslegalhelp.org/housing-apartments-shelter/public-subsidized-housing/types-grievances)
- [Reviewing a grievance decision](https://www.masslegalhelp.org/housing-apartments-shelter/public-subsidized-housing/getting-grievance-decision)
- [760 CMR 6.08](https://www.law.cornell.edu/regulations/massachusetts/760-CMR-6-08)
- [24 CFR 966.54](https://www.law.cornell.edu/cfr/text/24/966.54)

Sources checked November 22, 2026. MLRI's guide pages are marked reviewed in 2022; the current regulations were checked as well. The RTF download could not be independently fetched through the web tool. The existing student complaint template and current MLRI instructions support the letter's problem/request structure. This is a functional adaptation, not a claim of verbatim official-form reproduction.

## Review decisions

The old interview categorically excluded anyone involved in listed misconduct, even when the grievance was unrelated. The revision instead explains that some eviction disputes may not qualify and directs the user to their notice, lease, policy, and help. It does not decide grievance eligibility. It also removes the unsupported instruction to wait 30 days and then contact DHCD.

The project owner approved the integrated initial/hearing-request scope, linked MassLegalHelp appeal guidance, current-tenant limits, and non-blocking eviction warning on November 22, 2026. This is a scope decision, not a blanket legal or publication checklist attestation. Appeals are linked to the correct instructions rather than guessing a forum or extending the automated scope.
