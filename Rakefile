require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "divining_rod"
    gem.summary = %Q{A mobile phone web request profiler}
    gem.description = %Q{A mobile phone web request profiler using definitions that look like rails routes}
    gem.email = "mark@mpercival.com"
    gem.homepage = "http://github.com/mdp/divining_rod"
    gem.authors = ["Mark Percival"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test' << '.'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test
