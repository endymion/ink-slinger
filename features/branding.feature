Feature: Branding

Scenario: Localhost
  When my request is from the host localhost
  And I am on the home page
  Then the page is valid XHTML
  And I should see "Brave New Media"

Scenario: Brave New Media
  When my request is from the host miami.bravenewmedia.com
  And I am on the home page
  Then the page is valid XHTML
  And I should see "Brave New Media"
  
Scenario: Nightlife Site Title
  When my request is from the host nightlifeobserver.com
  And I am on the home page
  Then the page is valid XHTML
  And I should see "nightlife"