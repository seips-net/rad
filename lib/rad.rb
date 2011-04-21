require 'rubygems'
require 'pathname'
require 'optparse'
require 'yaml'
require 'fileutils'
require 'open-uri'
require 'readline'

require 'active_support/dependencies'

ActiveSupport::Dependencies.autoload_paths << Pathname.new(__FILE__).expand_path.dirname

module Rad
end

Rad::Config.run

# home = ENV['HOME'] || ENV['USERPROFILE'] || ENV['HOMEPATH']
# begin
#   config = YAML::load open(home + "/.rad")
# rescue
#   config = false
# end
#

if ARGV[0] == "install"
  Rad::Installer.run
elsif ARGV[0] == "test"
  Rad::Test.run
else
  Rad::Build.run
end