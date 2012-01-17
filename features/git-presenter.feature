Feature: Use GIT presenter to move forward through commits while presenting code at a conference

  Scenario: Initialise folder for presentation
    Given I have written the code for a presentation
    When I initialise the presentation
    And reset the folder to starting possition
    Then I should be on the first commit

  Scenario: Move forward in commits
    Given I have setup the code for presentation
    Then I start the presentation
    And I move to the next commit
