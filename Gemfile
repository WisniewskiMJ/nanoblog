source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.1.3'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bcrypt', '~> 3.1.7'
gem 'image_processing', '~> 1.2'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'haml', '~> 5.2', '>= 5.2.1'
gem 'haml-rails', '~> 2.0', '>= 2.0.1'
gem 'email_validator', '~> 2.2', '>= 2.2.2', require: 'email_validator/strict'
gem 'simple_form', '~> 5.1'
gem 'pagy', '~> 3.5'
gem 'rinku', '~> 2.0', '>= 2.0.6', :require => 'rails_rinku'
gem 'faker', '~> 2.17'
gem 'factory_bot_rails', '~> 6.1', '<=6.2.0'
gem 'dotenv-rails'
gem 'listen', '~> 3.3'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 5.0', '>= 5.0.1'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'launchy', '~> 2.5'
  gem 'sqlite3', '~> 1.4'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'spring'
  gem 'pry-rails', '~> 0.3.9'
  gem 'annotate', '~> 3.1', '>= 3.1.1'
  gem 'better_errors', '~> 2.9', '>= 2.9.1'
  gem 'binding_of_caller', '~> 1.0'
  gem 'rubocop-rails', '~> 2.9', '>= 2.9.1', require: false
  gem 'letter_opener', '~> 1.7'
  gem 'capistrano', require: false
  gem 'capistrano-asdf'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma', require: false
end

group :test do
  gem 'shoulda-matchers', '~> 4.5', '>= 4.5.1'
  gem 'capybara', '~> 3.35', '>= 3.35.3'
  gem 'database_cleaner', '~> 2.0', '>= 2.0.1'
end

group :production do
  gem 'pg', '~> 1.2', '>= 1.2.3'
  gem 'cloudinary', '~> 1.20'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
