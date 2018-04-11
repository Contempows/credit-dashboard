source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'ajax-datatables-rails'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-sass'
gem 'bootstrap', '~> 4.0.0'
gem 'bootstrap-will_paginate'
gem 'cancancan'
gem 'carrierwave-aws'
gem 'carrierwave-i18n'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'haml-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-datatables-rails', '~> 3.4.0'
gem 'jquery-rails'
gem 'mina'
gem 'mini_magick', git: 'git://github.com/minimagick/minimagick.git',
                   ref: '6d0f8f953112cce6324a524d76c7e126ee14f392'
gem 'nested_form'
gem 'newrelic_rpm'
gem 'oj', '~> 2.16.1'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.0.3'
gem 'rails-controller-testing'
gem 'redis-rails'
gem 'remotipart', '~> 1.2'
gem 'rollbar'
gem 'rubocop'
gem 'sass-rails', '~> 5.0'
gem 'select2-rails'
gem 'sidekiq'
gem 'simple_form'
gem 'trailblazer-rails'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'will_paginate'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'minitest-rspec_mocks'
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.5'
end

group :staging, :production do
  gem 'listen', '~> 3.0.5'
  gem 'therubyracer', require: 'v8'
end

group :development do
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
