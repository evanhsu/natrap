source 'http://rubygems.org'

#gem 'rails', '3.0.3'
gem 'rails', '4.1.9'
gem 'tzinfo-data', :group => :development #Required by ActiveRecord on Windows machines
gem 'rails_12factor', :group => :production #Required by Heroku to enable logging to stdout and serve-static-assets
gem 'jquery-rails'
gem 'rake', '10.4.2'

#gem 'mysql', :group => :development
#gem 'mysql2', '0.3.16'#, :group => :production
#gem 'activerecord-mysql2-adapter'#, :group => :production
#gem 'valkyrie' #Copy data from MySQL to PostgreSQL
gem 'pg' #Postgre adapter for Heroku

#include the calendar_date_select plugin
#gem 'calendar_date_select'#, '< 2.0'

#include the 'paperclip' gem for file-upload management
gem 'paperclip', '4.2.1'

#include the 'prawn' gem to generate PDF documents
gem 'prawn', '0.12.0'

#include the 'yaml_db' gem to create database backups using rake commands
#gem 'yaml_db', :git => "https://github.com/blanchma/yaml_db.git"
#gem 'yaml_db', github: 'jetthoughts/yaml_db', ref: 'fb4b6bd7e12de3cffa93e0a298a1e5253d7e92ba'
gem 'yaml_db', '0.3.0'

#include the 'whenever' gem to create cron jobs using Ruby-style code
gem 'whenever', '0.9.4'

###############################################
## GEMS FOR TRANSITION TO RAILS 4 #############
###############################################
#Rails-Observers needed with Rails 4.x to support the use of 'cache-sweeper'
gem 'rails-observers'
gem 'protected_attributes' #Remove after implementing 'strong parameters'
gem 'activerecord-deprecated_finders', require: 'active_record/deprecated_finders' # Remove calls to finders like 'Person.find_all_by_firstname'
## These gems should be phased out one at a time to allow for systematic debugging.
###############################################

group :development, :test do
  gem 'rspec-rails', '~> 3.2.1'
  
  #include 'bullet' to check for inefficient queries
  #The /initializers/bullet.rb file accompanies this gem
  gem 'bullet'
end

group :test do
  gem 'factory_girl_rails', '4.5.0'
  gem 'capybara', '2.4.4'
  gem 'database_cleaner', '1.4.0'
end

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
#group :test do
  # gem 'sqlite3-ruby', :require => 'sqlite3'
  # gem 'webrat'
#end

ruby '2.2.2'
