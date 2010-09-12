Feature: Sites are live

# @live
# Scenario: Check asset hosts
#   When I go through the asset hosts
#   Then I should be able to reach a known test file on each host

@live
Scenario: Check application hosts
  When I go through the application hosts
  Then I should be able to reach the index page on each host
  