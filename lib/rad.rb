require 'fileutils'
require 'open-uri'
require 'readline'

class Rad
  def self.run
    config
    select_runner
  end

  def self.config
    Rad::Configuration.run
  end

  def self.select_runner
    if ARGV[0] == "install"
      Rad::Installer.run
    elsif ARGV[0] == "test"
      Rad::Test.run
    elseif ARGV[0] == "create"
      Rad::Build.run
    end
  end
end

