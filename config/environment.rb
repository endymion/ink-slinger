# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Reporter::Application.initialize!

ActionController::Base.page_cache_directory = "/tmp"