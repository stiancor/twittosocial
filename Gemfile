source 'https://rubygems.org'
ruby '2.2.1'

gem 'rails', '3.2.22.1'
gem 'bootstrap-sass', '2.0.4'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'jquery-rails', '3.0.1'
gem 'rest-client', '1.6.7'
gem 'tire', '0.5.4'
gem 'newrelic_rpm'

group :development, :test do
  gem 'sqlite3', '1.3.11'
  gem 'rspec-rails', '3.4.2'
  gem 'test-unit'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :test do
  gem 'capybara'
  gem 'factory_girl_rails', '4.1.0'
  gem 'cucumber-rails', '1.2.1', :require => false
  gem 'database_cleaner', '0.7.0'
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end