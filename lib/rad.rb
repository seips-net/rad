require 'rubygems'
require 'pathname'
require 'optparse'
require 'yaml'
require 'fileutils'
require 'open-uri'
require 'readline'

RAD_LIB = Pathname.new(__FILE__).expand_path.dirname.join('..','lib')

require RAD_LIB.join('option_parser')
require RAD_LIB.join('rad','version')
require RAD_LIB.join('rad','installer')
require RAD_LIB.join('rad','build')
require RAD_LIB.join('rad','config')

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