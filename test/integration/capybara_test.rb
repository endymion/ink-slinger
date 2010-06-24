require 'integration_test_helper' 

class ClubTest < ActionController::IntegrationTest

  test "viewing clubs" do
    visit '/clubs'
    assert page.has_content?('Listing clubs')
  end

  test "adding a club" do
    visit '/clubs'
    click_link "New Club"
    assert page.has_content?('Create a new club')
    fill_in 'Name', :with => 'Capybara'
    check 'Exclusive'
    click 'Create Club'
    assert page.has_content?('Club was successfully created.')
    click_link "Back"
    assert page.has_content?('Listing clubs')
    assert page.has_content?('Capybara true')
    assert page.has_no_content?('Capybara false')
  end

end
