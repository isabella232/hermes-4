source 'https://rubygems.org'

gem 'rails', '~> 4.1.7'
gem 'devise'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'ranked-model', github: 'mixonic/ranked-model'
gem 'jbuilder', '~> 1.2'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'less-rails'
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'momentjs-rails', '>= 2.8.1'
gem 'bootstrap3-datetimepicker-rails', '~> 3.1.3'
gem 'sanitize-rails'
gem 'bootstrap-wysihtml5-rails'
gem 'haml-rails'
gem 'font-awesome-rails'
gem 'data-confirm-modal', github: 'ifad/data-confirm-modal'
gem 'animate-rails'
gem 'autosize-rails'
gem 'medium-editor-rails'
gem 'zeroclipboard-rails'
gem 'airbrake'
gem 'cancan'

group :doc do
  gem 'sdoc', require: false
end

group :test do
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'shoulda-matchers', require: false
  gem 'rspec-collection_matchers'
  gem 'vcr'
  gem 'fakeweb'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.1'
  gem 'guard-rspec', require: false
  gem 'ffaker'
  gem 'email_spec'
  gem "spring-commands-rspec"
end

group :development do
  gem 'mysql2'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'

  gem RUBY_VERSION.to_f < 2.0 ? 'debugger' : 'byebug'
end

group :production do
  gem 'unicorn'
  gem 'pg'
end
