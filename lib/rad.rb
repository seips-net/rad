require 'fileutils'
require 'open-uri'
require 'readline'

class Rad
  def self.run
    config
    option
    select_runner
  end
  
  def self.option
    @options, @parser = Rad::Option.parse
  end

  def self.config
    Rad::Configuration.run
  end

  def self.select_runner
    if ARGV[0] == "install"
      Rad::Installer.run
    elsif ARGV[0] == "test"
      Rad::Test.run
    elsif ARGV[0] == "create"
      sketch_name = ARGV[1]
      @parser.parse!(["-h"]) unless sketch_name
      Rad::Build.run sketch_name, @options
    end
  end
end

