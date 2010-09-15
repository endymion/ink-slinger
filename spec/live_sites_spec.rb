require 'spec_helper'

# Use Capybara.
require 'capybara'
require 'capybara/dsl'
require 'capybara/rails'
RSpec.configure do |config|
  config.include Capybara
end

# Use Selenium, to test real live sites with a real web browser.
Capybara.current_driver = :selenium

# Use the real config/brands.yml, not the testing configuration.
DatabaseCleaner.clean_with :truncation
Brand.seed

describe "live servers" do

  describe "asset hosts" do
    @urls = Brand.asset_hosts.map { |host| 'http://' + host }
    @urls.each do |url|
      it url do
        Capybara.app_host = url
        visit('/test.html')
        page.should have_content 'Success'
      end
    end
  end
  
  # describe "application hosts" do
  #   @urls = Brand.application_hosts.map { |host| 'http://' + host }
  #   @urls.each do |url|
  #     it url do
  #       host = url
  #       host = 
  #       Capybara.app_host = url
  #       visit('/')
  #       page.should have_css '#page'
  #     end
  #   end
  # end
  # 
  # describe "application caches" do
  #   @urls = Brand.application_hosts.map { |host| 'http://' + host }
  #   @urls.each do |url|
  #     it url do
  #       Capybara.app_host = url
  #       visit('/')
  #       page.should have_css '#page'
  #     end
  #   end
  # end
  
end