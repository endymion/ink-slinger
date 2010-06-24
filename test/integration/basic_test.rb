require 'integration_test_helper' 

class BasicTest < ActionController::IntegrationTest

  test "viewing root" do
    visit '/'
    assert page.has_content?('Rails')
  end

end
