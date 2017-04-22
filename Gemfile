# @todo change rubygems to https when cert fixed on appserver
source 'https://rubygems.org'
ruby '2.4.1'

gem 'rails', '3.2.21'
gem 'jquery-rails'

gem 'invalid_utf8_rejector', github: 'opengovernment/invalid_utf8_rejector'

gem 'rack-cors', :require => 'rack/cors'

gem 'mongoid', '~> 3.1.2'
gem 'geocoder' # must be after mongoid
gem 'rmagick'
gem 'carrierwave', '~> 0.9.0'
gem 'carrierwave-mongoid'
gem 'carrierwave-video-thumbnailer'
gem 'vidibus-validate_uri'
gem 'client_side_validations'
gem 'client_side_validations-mongoid'
gem 'sidekiq', '3.2.1' # anything above requires ruby > 1.9.3
gem 'inherited_resources', '~> 1.5.1'
gem 'simple_form'
gem 'kaminari'
gem 'coveralls', require: false

# aka state machine management
gem 'workflow_on_mongoid'

# Authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-gplus'

# Authorization
gem 'authority'
gem 'rolify'

# Rake tasks
gem 'ruby-progressbar'
gem 'rest-client'

# Google Civic Information API, used for representatives for address
gem 'google_civic_info', github: 'walter/google_civic_info'

# Twitter API, used for looking up possible recipients
gem 'twitter', '5.5.1'

# need the latest from master until at least 1.6.2
gem 'auto_html', github: 'opengovernment/auto_html'

# use pry as console, even in production
gem 'pry-rails'

group :production do
  gem 'airbrake'
  gem 'fog', '1.14.0'
  gem 'newrelic_rpm', '3.7.3.204'
  gem 'nokogiri'
end

group :heroku do
  gem 'unicorn'
end

group :development do
  gem 'ruby-growl', '3.0'
  gem 'bullet'
  gem 'capistrano'
  gem 'rvm-capistrano'  # https://rvm.io/integration/capistrano/ and https://github.com/wayneeseguin/rvm-capistrano
end

group :test, :development do
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'mongoid-rspec'
  gem 'vcr' # play back external HTTP requests
  gem 'webmock' # stub and mock external HTTP requests
  gem 'poltergeist'
  gem 'fakeredis', require: 'fakeredis/rspec'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

  # only precompile assets when changed
  gem 'turbo-sprockets-rails3'
end
