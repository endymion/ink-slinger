source 'http://rubygems.org'

gem 'rails', '3.0.0.rc'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
gem 'ruby-debug', "= 0.10.0"

# Bundle the extra gems:
gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'aws-s3', :require => 'aws/s3'
# gem "subdomain-fu", :git => "git://github.com/nhowell/subdomain-fu.git"
gem "subdomain-fu", :path => File.join(File.dirname(__FILE__), '/vendor/gems/subdomain-fu')
gem "haml"
gem "compass"
gem "compass-susy-plugin"
gem "rmagick"
gem 'acts-as-taggable-on'
#gem 'formtastic', :git => "http://github.com/justinfrench/formtastic.git", :branch => "rails3"
#gem 'will_paginate', :git => 'http://github.com/mislav/will_paginate.git',   :branch => 'rails3'
gem 'formtastic',    :path => File.join(File.dirname(__FILE__), '/vendor/gems/formtastic')
gem 'will_paginate', :path => File.join(File.dirname(__FILE__), '/vendor/gems/will_paginate')
gem 'paperclip'
gem 'factory_girl'
gem 'annotate'

group :test do
  gem 'nokogiri', '1.4.1'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'culerity'
  gem 'celerity', :require => nil # JRuby only. Make it available but don't require it in any environment.
  gem 'webrat'
  gem "capybara"
  gem "launchy"

  gem "rspec-rails", ">= 2.0.0.beta.17"
  gem "ZenTest"

  # gem "rspec-rails",        "2.0.0.beta.10", :git => "git://github.com/rspec/rspec-rails.git"
  # gem "rspec",              "2.0.0.beta.10", :git => "git://github.com/rspec/rspec.git"
  # gem "rspec-core",         "2.0.0.beta.10", :git => "git://github.com/rspec/rspec-core.git"
  # # gem "rspec-expectations", "2.0.0.beta.10", :git => "git://github.com/rspec/rspec-expectations.git"
  # # gem "rspec-mocks",        "2.0.0.beta.10", :git => "git://github.com/rspec/rspec-mocks.git"
end
