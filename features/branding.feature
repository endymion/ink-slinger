Feature: Branding

Scenario: Brave New Media
  When my request is from the host miami.bravenewmedia.com
  And I am on the home page
  Then I should see "Brave New Media"
  
Scenario: Nightlife Site Title
  When my request is from the host nightlifeobserver.com
  And I am on the home page
  Then I should see "nightlife"