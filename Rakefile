require 'rubygems'
require 'rake'

require 'yaml'
YAML::ENGINE.yamler='psych' if defined?(YAML::ENGINE)

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "madrona-rad"
    gem.summary = %Q{RAD: Ruby Arduino Development - 0.4.1 -- 1.9 Ready!}
    gem.description = %Q{Ruby Arduino Development: a framework for programming the Arduino physcial computing platform using Ruby}
    gem.email = "jd@jdbarnhart.com"
    gem.homepage = "http://github.com/madrona/madrona-rad"
    gem.authors = ["JD Barnhart", "Greg Borenstein"]
    gem.add_dependency "ruby2c", ">= 1.0.0.7"
    gem.add_dependency "sexp_processor", ">=3.0.2"
    gem.add_dependency "rubyzip", "~> 0.9.5"
    gem.add_dependency "thoughtbot-shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "madrona-rad #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
