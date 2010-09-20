require File.dirname(__FILE__) + '/acceptance_helper'

feature "W3C Validation" do

  before :all do
    Capybara.use_default_driver
    Capybara.run_server = true
  end

  scenario "HTML" do
    validate_url '/'
  end

  # scenario "feed XML" do
  # end

end
