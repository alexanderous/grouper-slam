source 'https://rubygems.org'

gem 'rails', '3.2.11' #the foundation
gem 'jquery-rails', '2.1.2' #adds jquery language
gem 'bootstrap-sass', '2.3.0.1' #twitter's incredible cross-browser formatting tool
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3' #pagination
gem 'bootstrap-will_paginate', '0.0.5' #pagination
gem 'carrierwave' #uploads images
gem 'delayed_job_active_record'
gem "sidekiq" #adds multitasking ability to app
gem 'carrierwave_backgrounder', '0.1.3' #this is to make image uploading in background
gem 'fog', '~> 1.3.1' #adds amazon uploading feature
#gem 'aws-s3', :require => 'aws/s3' #stores image data on amazon for quick dl
#gem 'carrierwave_direct' #uploads directly to S3 in the background (joint with sidekiq)
gem "rmagick" #modifies image uploads
gem "omniauth-google-oauth2"

gem 'pg', "~> 0.14.1.pre" #adds postgres databasing feature
gem 'newrelic_rpm' #3rd party plug-in that evaluates speed of website
gem 'amistad' #adds friend-type relationships
gem 'redis' #this is for sidekiq and search autocomplete
gem 'sinatra', require: false #this is to see sidekiq processes through GUI
gem 'slim' #this is to see sidekiq processes through GUI
gem 'capistrano' #this deploys sidekiq
gem 'rack-timeout' #this helps with timeout issues
gem 'rack-mini-profiler' #this is for testing how much time it takes for a search
gem 'intercom-rails', '~> 0.2.14'
gem 'chardinjs-rails'
gem 'garlicjs-rails'

group :development, :test do
  gem 'rspec-rails', '2.9.0'
  gem 'guard-rspec', '0.5.5'
end

gem 'annotate', '2.5.0', group: :development

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.4'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
  #gem 'asset_sync' 
end

group :test do
  gem 'capybara', '1.1.2', :require => false
  gem 'factory_girl_rails', '1.4.0', :require => false #more dynamic form testing
  gem 'cucumber-rails', '1.2.1', :require => false #more readable testing
  gem 'database_cleaner', '0.7.0'
  gem 'rb-fsevent', '0.9.1', :require => false
  gem 'growl', '1.0.3'
  gem 'guard-spork', '0.3.2'  
  gem 'spork', '0.9.0'
  gem 'launchy', '2.1.0'
end

group :production do
  #gem 'thin'
  gem 'unicorn' #speeds up website
  #gem 'asset_sync'
end

