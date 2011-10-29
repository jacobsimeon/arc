source "http://rubygems.org"
#this needs to get added to gemspec eventually
gem 'q', :path => '~/Projects/jacobsimeon/q'

group :test do
  gem 'arel', :path => "../arel"
  gem 'rspec'
  gem 'simplecov', '>= 0.4.0', :require => false
  gem 'ruby-debug19', :require => 'ruby-debug'
  group :sqlite do
    gem 'sqlite3'
  end
  group :postgres do
    gem 'pg'
  end
  group :mysql do
    gem 'mysql2'
  end
end

gemspec
