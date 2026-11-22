Feature: One public housing grievance tool for complaint and hearing request

  Scenario: State public housing tenant starts a repair grievance
    Given the maximum seconds for each step is 90
    And I start the interview at "lt3grievancecomplaint.yml"
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
    And the downloaded PDF "public_housing_grievance_letter.pdf" should contain "I am filing a grievance"
    And the downloaded PDF "public_housing_grievance_letter.pdf" should contain "Repair the ceiling and stop the leak."
    And the downloaded PDF "public_housing_grievance_letter.pdf" should not contain "my informal meeting did not resolve"
    When I follow the review link containing "Edit answers"
    And I follow the review link containing "What would fix the problem"
    And I get to "grievance review" with this data:
      | var | value |
      | action_requested | Stop the leak and repair the water-damaged wall. |
    And I continue
    And I download "public_housing_grievance_letter.pdf"
    Then the downloaded PDF "public_housing_grievance_letter.pdf" should contain "Stop the leak and repair the water-damaged wall."
    And the downloaded PDF "public_housing_grievance_letter.pdf" should not contain "Repair the ceiling and stop the leak."
    When I follow the review link containing "Edit answers"
    And I follow the review link containing "Request:"
    And I get to "grievance review" with this data:
      | var | value |
      | grievance_stage | appeal |
    And I continue
    Then I should see the phrase "This tool does not prepare an appeal"
    And I follow the review link containing "Change my request"
    And I get to "download lt3grievancecomplaint" with this data:
      | var | value |
      | grievance_stage | initial |
    And I download "public_housing_grievance_letter.pdf"
    Then the downloaded PDF "public_housing_grievance_letter.pdf" should contain "Jordan Rivera"
    And the downloaded PDF "public_housing_grievance_letter.pdf" should contain "Stop the leak and repair the water-damaged wall."

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
    And the downloaded PDF "public_housing_grievance_letter.pdf" should contain "my informal meeting did not resolve"
    And the downloaded PDF "public_housing_grievance_letter.pdf" should contain "Correct my account and withdraw the termination notice."
    And the downloaded PDF "public_housing_grievance_letter.pdf" should not contain "I am filing a grievance"

  Scenario: Tenant with a hearing decision gets appeal guidance instead of the wrong letter
    Given the maximum seconds for each step is 90
    And I start the interview at "lt3grievancecomplaint.yml"
    When I get to "grievance appeal guidance" with this data:
      | var | value |
      | acknowledged_information_use | True |
      | eligible_tenant | True |
      | housing_program | state |
      | grievance_stage | appeal |
    Then I should see the phrase "This tool does not prepare an appeal"
    And I should see the phrase "14 days"
