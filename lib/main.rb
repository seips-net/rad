require 'rubygems'
require 'pathname'
require 'active_support/dependencies'

RAD_LIB = Pathname.new(__FILE__).expand_path.dirname
ActiveSupport::Dependencies.autoload_paths << RAD_LIB

Rad.run