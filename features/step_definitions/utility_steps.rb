Given /^my request is from the host (\S+)$/ do |host|
  # host! host
  Capybara.default_host = host
end

When /^I visit (\S+)$/ do |URL|
  visit("http://#{URL}/") 
end

Then %r/the page is valid XHTML/ do
  $browser.html.should be_xhtml_strict if ENV["VALIDATION"]
end