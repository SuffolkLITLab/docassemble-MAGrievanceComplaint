@test
Feature: I only tests part way through forms

Scenario: I take a short path through the form
  Given I start the interview at "lt3grievancecomplaint.yml"
  And the user gets to "action_requested" with this data:
    | var | value | trigger |
    | acknowledged_information_use | True |  |
    | al_intro_screen | True |  |
    | lt3grievancecomplaint_intro | True |  |
    | user_ask_role | plaintiff |  |
    | users[0].name.first | John |  |
    | users[0].name.middle | J |  |
    | users[0].name.last | Brandt |  |
    | users[0].name.suffix |  |  |
    | users[0].address.location.known | False |  |
    | users[0].address.address | 69 Prince St |  |
    | users[0].address.unit |  |  |
    | users[0].address.city | Boston |  |
    | users[0].address.state | MA |  |
    | users[0].address.zip | 02113 |  |
    | users[0].location.known | False |  |
    | users[0].mailing_address.location.known | False |  |
    | users[0].service_address.location.known | False |  |
    | users.there_are_any | True |  |
    | users.there_is_another | --- invalid. See docs at https://suffolklitlab.org/docassemble-AssemblyLine-documentation/docs/automated_integrated_testing/#there_is_another-loop ---  |  |
    | users.revisit | True |  |
    | al_person_answering | user |  |
    | complaint_facts | I did not receive notice of an increase in rent. |  |
    | sharing_choices[0]['tell_friend'] | Tell a friend about this website |  |
    | sharing_choices[1]['share_answers'] | Share my answers and progress with someone |  |