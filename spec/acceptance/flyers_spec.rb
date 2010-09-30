require File.dirname(__FILE__) + '/acceptance_helper'

feature "Flyers" do

  # before :all do
  #   Capybara.current_driver = :selenium
  #   Capybara.run_server = true
  # end

  background do
    @user = User.create
    @user.confirm!
    login_as @user
  end

  scenario "Upload a flyer, crop it, and then delete it" do
    visit '/topics'
    click_link 'new topic'
    attach_file('topic[images_attributes][0][t_1]', File.join(Rails.root + 'spec/fixtures/images/test_1024.jpg'))
    click 'topic_submit'
    click 'topic_submit' # On crop page.
    click 'Topics'
    click 'destroy'
    page.should_not have_content 'destroy'
  end


end
