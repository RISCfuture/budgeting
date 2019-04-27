ruby '2.6.3'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# FRAMEWORK
gem 'bootsnap'
gem 'puma'
gem 'rails', '5.2.3'

# MODELS
gem 'pg'

# CONTROLLERS
gem 'responders'

# VIEWS
gem 'jbuilder'

# ASSETS
gem 'autoprefixer-rails'
gem 'sass-rails'
gem 'slim-rails'
gem 'webpacker'

# ERROR TRACKING
gem 'bugsnag'

group :development do
  # ERRORS
  gem 'better_errors'
  gem 'binding_of_caller'

  # HOT RELOADING
  gem 'listen'
end

group :doc do
  gem 'redcarpet'
  gem 'yard'
end

group :test do
  # SPECS
  gem 'rails-controller-testing'
  gem 'rspec-rails'

  # FACTORIES
  gem 'factory_bot_rails'
  gem 'ffaker'

  # ENVIRONMENT
  gem 'database_cleaner'
  gem 'fakefs', require: 'fakefs/safe'
  gem 'timecop'
  gem 'webmock'
end
