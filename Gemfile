source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails',                      '6.1.4.1'
gem 'rspec',                      '~> 3.0'
gem 'image_processing',           '1.9.3'
gem 'mini_magick',                '4.9.5'
gem 'active_storage_validations', '0.8.9'
gem 'bcrypt',                     '3.1.13'
gem 'faker',                      '2.11.0'
gem 'will_paginate',              '3.3.0'
gem 'bootstrap-will_paginate',    '1.0.0'
gem 'bootstrap-sass', '3.4.1'
gem 'puma',           '5.3.1'
gem 'sass-rails',     '6.0.0'
gem 'webpacker',      '5.4.0'
gem 'turbolinks',     '5.2.1'
gem 'jbuilder',       '2.10.0'
gem 'bootsnap',       '1.7.2', require: false
gem 'pry-byebug',     '3.9.0'

group :development, :test do
  gem 'sqlite3', '1.4.2'
end

group :development do
  gem 'web-console',           '4.1.0'
  gem 'listen',                '3.4.1'
  gem 'spring',                '2.1.1'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'capybara',                 '3.35.3'
  gem 'selenium-webdriver',       '3.142.7'
  gem 'webdrivers',               '4.6.0'
  gem 'rails-controller-testing', '1.0.5'
  gem 'minitest',                 '5.11.3'
  gem 'minitest-reporters',       '1.3.8'
  gem 'guard',                    '2.16.2'
  gem 'guard-minitest',           '2.4.6'
end

group :production do
  #gem 'pg',         '1.2.3'
  gem 'aws-sdk-s3', '1.87.0', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Uncomment the following line if you're running Rails
# on a native Windows system:
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]