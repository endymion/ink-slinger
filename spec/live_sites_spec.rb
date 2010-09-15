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

# Use the real config/brands.yml, not the testing configuration from spec_helper.
DatabaseCleaner.clean_with :truncation
Brand.seed

describe "Live" do

  describe "asset hosts" do
    urls = Brand.asset_hosts.map { |host| 'http://' + host }
    urls.each do |url|
      it url do
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
      it url do
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
      it url do
        Capybara.app_host = url
        visit('/')
        page.should have_css '#page'
      end
    end
  end
  
end