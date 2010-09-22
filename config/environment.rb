# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
InkSlinger::Application.initialize!

ActionController::Base.page_cache_directory = "./tmp" # For Heroku.

# Hack friendly_id to stop it from creating a new slug when a Topic is updating its
# associated Image and Panel records to set the file names.
require 'friendly_id_no_slug'