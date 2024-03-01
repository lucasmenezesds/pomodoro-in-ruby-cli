# frozen_string_literal: true

source 'https://rubygems.org'

gem 'gir_ffi', '~> 0.15.7'
gem 'rake', '~> 13.0'
gem 'ruby-progressbar', '~> 1.11'
gem 'tty-box', '~> 0.7.0'
gem 'tty-prompt', '~> 0.23.1'

group :development do
  gem 'guard-rspec', require: false
  gem 'pry'
  gem 'rubocop', '~> 1.7', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
end

group :test, :development do
  gem 'rspec', require: false
end

# Specify your gem's dependencies in pirb-cli.gemspec
gemspec
