# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SimpleStore::Application.initialize!

# We don't need json to include root
ActiveRecord::Base.include_root_in_json = false