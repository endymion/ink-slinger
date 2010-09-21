# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
InkSlinger::Application.initialize!

ActionController::Base.page_cache_directory = "./tmp" # For Heroku.