source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.1.2"

gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem 'graphql'
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem 'httparty'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem 'rspec-rails'
  gem 'vcr'
  gem 'rails-controller-testing'
end
gem "graphiql-rails", group: :development
