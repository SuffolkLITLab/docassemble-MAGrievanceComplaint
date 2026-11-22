Feature: One public housing grievance tool for complaint and hearing request

  Scenario: State public housing tenant starts a repair grievance
    Given the maximum seconds for each step is 90
    And I start the interview at "lt3grievancecomplaint.yml"
    When I get to "grievance introduction" with this data:
      | var | value |
      | acknowledged_information_use | True |
    Then I should see the phrase "You do not need to file a grievance first."
    And I should see the link to "https://uptocode.org/"
    And I should see the link to "https://www.gbls.org/MADE"
    When I get to "download lt3grievancecomplaint" with this data:
      | var | value |
      | acknowledged_information_use | True |
      | eligible_tenant | True |
      | housing_program | state |
      | grievance_stage | initial |
      | eviction_issue | False |
      | users[0].name.first | Jordan |
      | users[0].name.last | Rivera |
      | users[0].address.address | 10 Main Street |
      | users[0].address.unit | 2 |
      | users[0].address.city | Boston |
      | users[0].address.state | MA |
      | users[0].address.zip | 02108 |
      | housing_authority_name | Example Housing Authority |
      | housing_authority_address | 20 Main Street, Boston, MA 02108 |
      | complaint_facts | I reported a leaking ceiling on November 10. It is still leaking. |
      | action_requested | Repair the ceiling and stop the leak. |
      | letter_date | 11/22/2026 |
    Then I should see the phrase "This tool has not sent anything"
    And I download "public_housing_grievance_letter.pdf"
    And I download "public_housing_grievance_instructions.pdf"
    And the text in the JSON variable "grievance_stage" should be
      """
      initial
      """
    And the text in the JSON variable "action_requested" should be
      """
      Repair the ceiling and stop the leak.
      """

  @federal
  Scenario: Federal tenant requests a hearing after an unresolved meeting
    Given the maximum seconds for each step is 90
    And I start the interview at "lt3grievancecomplaint.yml"
    When I get to "download lt3grievancecomplaint" with this data:
      | var | value |
      | acknowledged_information_use | True |
      | eligible_tenant | True |
      | housing_program | federal |
      | grievance_stage | hearing |
      | eviction_issue | True |
      | users[0].name.first | Taylor |
      | users[0].name.last | Chen |
      | users[0].address.address | 30 Oak Street |
      | users[0].address.city | Worcester |
      | users[0].address.state | MA |
      | users[0].address.zip | 01608 |
      | housing_authority_name | Example Housing Authority |
      | housing_authority_address | 40 Oak Street, Worcester, MA 01608 |
      | complaint_facts | At our November 20 meeting, I showed my rent receipts. The authority still says rent is unpaid. |
      | action_requested | Correct my account and withdraw the termination notice. |
      | letter_date | 11/22/2026 |
    Then I should see the phrase "Download and send your letter"
    And I download "public_housing_grievance_letter.pdf"
    And I download "public_housing_grievance_instructions.pdf"
    And the text in the JSON variable "grievance_stage" should be
      """
      hearing
      """
    And the text in the JSON variable "action_requested" should be
      """
      Correct my account and withdraw the termination notice.
      """

  Scenario: Tenant with a hearing decision gets appeal guidance instead of the wrong letter
    Given the maximum seconds for each step is 90
    And I start the interview at "lt3grievancecomplaint.yml"
    When I get to "grievance appeal guidance" with this data:
      | var | value |
      | acknowledged_information_use | True |
      | eligible_tenant | True |
      | housing_program | state |
      | grievance_stage | appeal |
    Then I should see the phrase "This tool does not make an appeal letter"
    And I should see the phrase "14 days"
    And I should see the link to "https://www.gbls.org/MADE"
    And I should not see the phrase "Download and send your letter"
    And the text in the JSON variable "grievance_stage" should be
      """
      appeal
      """
