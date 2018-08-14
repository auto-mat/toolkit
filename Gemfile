source 'http://rubygems.org'

gem 'activerecord-postgis-adapter', '~> 3.0'
gem "pg", "~> 0.20.0" # https://github.com/rgeo/activerecord-postgis-adapter/pull/257#issuecomment-309553871
gem 'rails', '~> 4.2.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
# Only uncomment the debugger if you are using it as it slows things down
# gem 'ruby-debug19', require: 'ruby-debug'

# Front-end gems
gem 'browserify-rails'
gem 'chartkick'
gem 'formtastic'
gem 'haml-rails'
gem 'jqcloud-rails', github: 'GovSciences/jqcloud-rails'
gem 'jquery-rails', '~> 3.1.0'
gem 'kaminari'
gem 'kaminari-i18n'
gem 'leaflet-rails', "= 0.7.7"
gem 'map_layers'
gem 'rails-jquery-autocomplete'
gem 'rails_autolink'
gem 'ratelimit'
gem 'retryable'
gem 'rgeo-geojson', "< 1.0"
# gem 'jquery-turbolinks'

# Back-end gems
gem 'aasm'
gem 'actionview-encoded_mail_to'
gem 'attribute_normalizer'
gem 'declarative_authorization'
gem 'devise', '~> 3.4.0'
gem 'devise-i18n'
gem 'devise_invitable', '= 1.5.3' # Need to add accept_until_format
gem 'dragonfly', '~> 1.0.3'
gem 'draper'
gem 'email_reply_parser'
gem 'excon'
gem 'foreman'
gem 'http_accept_language'
gem 'icalendar'
gem 'mustache'
gem 'paranoia', '~> 2.0'
gem 'rack-cache', require: 'rack/cache'
gem 'redis-rails'
gem 'resque'
gem 'resque-rollbar'
gem 'thin'
gem 'thumbs_up', '~> 0.4.6'
gem 'whenever'

gem 'grape'
gem 'grape-kaminari'
gem 'kaminari-grape'
gem 'grape-swagger'
gem 'grape-swagger-rails'

gem 'rack-cors', require: 'rack/cors'
gem 'rakismet'
gem 'rollbar'

gem 'coffee-rails', '~> 4.1.0'
gem 'compass-rails'
gem 'jquery-ui-rails', '~> 5.0.0'
gem 'sass-rails', '~> 5.0'
# gem 'turbolinks'
gem 'nokogiri', '~> 1.8.1'
gem 'rails-i18n', '~> 4.0.0'
gem 'rails-observers'
gem 'sunspot_rails', github: 'sunspot/sunspot'
gem 'sunspot_solr', github: 'sunspot/sunspot'
gem 'progress_bar'
gem 'tagsinput-rails'
gem 'uglifier', '>= 1.3.0'
gem 'will-paginate-i18n'
gem 'lograge'

group :development do
  gem 'annotate', '>= 2.5.0', require: false
  gem 'bullet'
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'rubocop'
  # Following is required for Resque workers in development to load due to
  # declarative_authorization development dependency when Rails engines are eager loaded
  gem 'ruby_parser'
end

group :development, :test do
  gem 'parallel_tests'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'ruby-prof'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'rspec-collection_matchers'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'shoulda-matchers'
  gem 'sunspot_test'
  gem 'test_after_commit'
  gem 'webmock'
end
