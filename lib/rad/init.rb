require 'rubygems'
require 'pathname'

PROJECT_ROOT = Pathname.new(__FILE__).expand_path.dirname.join('..','..') unless defined?(PROJECT_ROOT)
PROJECT_DIR_NAME = PROJECT_ROOT.basename unless defined?(PROJECT_DIR_NAME)
PLUGIN_C_VAR_TYPES = "int|void|unsigned|long|short|uint8_t|static|byte|char\\*|uint8_t"

gem "ruby2c", "~>1.0.0.7"

#%w(generators/makefile.rb rad_processor.rb rad_rewriter.rb rad_type_checker.rb variable_processing.rb arduino_sketch.rb arduino_plugin.rb hardware_library.rb tasks/rad.rb sketch_compiler.rb).each do |path|
#  require RAD_LIB.join('rad',path)
#end