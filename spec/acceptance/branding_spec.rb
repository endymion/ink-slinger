require File.dirname(__FILE__) + '/acceptance_helper'

feature "Branding" do

  before :all do
    Capybara.use_default_driver
    Capybara.run_server = true
  end

  scenario "Master brand match" do
    visit 'http://the-master-brand.com'
    page.should have_content 'The Master Brand'
  end

  scenario "Publication match" do
    visit 'http://miami.something-chronicle.com/'
    page.should have_content 'The Miami Something Chronicle'
    visit 'http://los-angeles.something-chronicle.com/'
    page.should have_content 'The Los Angeles Something Chronicle'
  end

  scenario "No brand match" do
    visit 'http://no-brand.com'
    page.should have_content 'The Master Brand'
  end

end
