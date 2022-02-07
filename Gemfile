# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

gem 'twitter'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'simplecov'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'rubocop-rails'
end
