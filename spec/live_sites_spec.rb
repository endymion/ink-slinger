require 'spec_helper'

# Use Capybara.
require 'capybara'
require 'capybara/dsl'
require 'capybara/rails'
RSpec.configure do |config|
  config.include Capybara
end

describe "Live" do

  # Use the real config/brands.yml, not the testing configuration from spec/support/javascript.rb.
  Brand.configuration = YAML::load_file('config/brands.yml')
  DatabaseCleaner.clean_with :truncation
  Brand.seed
  
  before :all do
    # Use Selenium, to test real live sites with a real web browser.
    Capybara.current_driver = :selenium
    Capybara.run_server = false
  end

  describe "asset hosts" do
    urls = Brand.asset_hosts.map { |host| 'http://' + host }
    urls.each do |url|
      it url, {:noclean => true} do
        Capybara.app_host = url
        visit('/test.html')
        page.should have_content 'Success'
      end
    end
  end
  
  describe "application hosts" do
    brands = Brand.all
    brands.each do |brand|
      url = brand.application_host
      it url, {:noclean => true} do
        Capybara.app_host = url
        visit('/')
        page.should have_css '#page'
      end
    end
  end
  
  describe "application caches" do
    brands = Brand.all
    brands.each do |brand|
      url = brand.application_cache_host
      next if url.blank?
      it url, {:noclean => true} do
        Capybara.app_host = url
        visit('/')
        page.should have_css '#page'
      end
    end
  end

end