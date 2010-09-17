require File.dirname(__FILE__) + '/acceptance_helper'

feature "Flyers" do

  before :all do
    Capybara.current_driver = :selenium
    Capybara.run_server = true
  end

  scenario "Upload a flyer, crop it, and then delete it" do
    visit '/topics'
    click_link 'new topic'
    attach_file('topic[images_attributes][0][tile_256]', File.join(Rails.root + 'spec/fixtures/images/test_1024.jpg'))
    click 'topic_submit'
    click 'topic_submit' # On crop page.
    click 'Topics'
    page.evaluate_script('window.confirm = function() { return true; }')
    click 'destroy'
  end

end
