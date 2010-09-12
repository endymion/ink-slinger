When /^I go through the asset hosts$/ do
  # Add all asset subdomains.
  @urls = urls(Brand.asset_hosts)
end

Then /^I should be able to reach a known test file on each host$/ do
  Capybara.current_driver = :selenium
  @urls.each do |url|
    puts "Testing asset server: #{url}"
    Capybara.app_host = url
    visit('/test.html')
    page.should have_content 'Success'
    puts "Success"
  end
end

When /^I go through the application hosts$/ do
  @urls = urls(Brand.application_hosts)
end

Then /^I should be able to reach the index page on each host$/ do
  Capybara.current_driver = :selenium
  puts "URLS: #{@urls}"
  @urls.each do |url|
    puts "Testing: #{url}"
    Capybara.app_host = url
    visit('/')
    page.should have_css '#page'
    puts "Success"
  end
end

def urls(hosts)
  hosts.map { |host| 'http://' + host }
end