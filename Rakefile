require 'bundler/gem_tasks'
task :test do
  ['sqlite', 'postgres', 'mysql'].each do |environment|
    puts "Running tests for environment #{environment}"
    ENV['ARC_ENV'] = environment
    system 'rspec spec'
  end
end

task :setup do
  #setup postgres
  `createdb arc_development -O jacob`
  puts "Setup complete"
end

task :publish do
  require './lib/arc/version'
  package = "arc-#{Arc::VERSION}.gem"
  package_path = File.join(File.expand_path("pkg", Dir.pwd), package)
  if File.exists? package_path
    system "gem push #{package_path}"
  else
    puts "gem package \"#{package_path}\" does not exist."
  end
end

task :yank do
  system "gem yank arc"
end

namespace :test do
  task :adapter, :env do |task, args|
    ENV['ARC_ENV'] = args.env
    system 'rspec spec/data_stores/integration/'
  end
  task :docs do
    `rspec spec -f h > doc/spec.html`
  end
  task :wip do
    system "rspec spec --tag wip"
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