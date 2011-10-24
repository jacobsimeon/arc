require 'bundler/gem_tasks'
task :test do
  ['sqlite', 'mysql'].each do |environment|
    puts "Running tests for environment #{environment}"
    ENV['ARC_ENV'] = environment
    system 'rspec spec'
  end
end

namespace :test do
  task :adapter, :env do |task, args|
    ENV['ARC_ENV'] = args.env
    system 'rspec spec/data_stores/data_store_spec.rb'    
  end
  task :report do
    `rspec spec -f h > notes/spec.html`
  end
end

#example use of passing arguments to rake
# task :say, :word, :person do |task, args|
#   puts task
#   puts '"args.word"'
#   puts "\t- #{args.person}"
# end
# $ rake say[hello,"Jacob Morris"]
# >>  say
# >>  "hello"
# >>    - Jacob Morris