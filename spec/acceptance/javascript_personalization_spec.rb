require File.dirname(__FILE__) + '/acceptance_helper'

feature "Flyers" do

  before :all do
    Capybara.current_driver = :selenium
    Capybara.run_server = true
  end

  scenario "" do
    visit '/'
    page.should have_css '#authentication-box input'
  end


end
