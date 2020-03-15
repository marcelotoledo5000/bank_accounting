# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'bcrypt', '~> 3.1'
gem 'bootsnap', '~> 1.4', require: false
gem 'jbuilder', '~> 2.10'
gem 'kaminari', '~> 1.2'
gem 'pg', '~> 1.2'
gem 'puma', '~> 4.3'
gem 'rack-cors', '~> 1.1'
gem 'rails', '~> 6.0'

group :development, :test do
  gem 'database_cleaner', '~> 1.8'
  gem 'factory_bot_rails', '~> 5.1'
  gem 'faker', '~> 2.10'
  gem 'pry-byebug', '~> 3.8'
  gem 'rspec-rails', '~> 4.0.0.rc1'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubycritic'
  gem 'shoulda-matchers', '~> 4.3'
  gem 'simplecov'
end

group :development do
  gem 'brakeman'
  gem 'listen', '~> 3.2'
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 4.0'
end
