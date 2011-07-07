require 'erb'
require 'yaml'

class Rad::Makefile
  class << self
    
    # build the sketch Makefile for the given template based on the values in its software and hardware config files
    def compose_for_sketch(build_dir)
      params
      arduino_root = Pathname.new @params['arduino_root']
      board_config = board_configuration(arduino_root, @params['mcu'])
      @params.merge! board_config
      @params['target'] = build_dir.split.last
      #params['libraries_root'] = PROJECT_ROOT.join('vendor','libraries')
      @params['libraries'] = $load_libraries # load only libraries used 
      # needed along with ugly hack of including another copy of twi.h in wire, when using the Wire.h library
      @params['twi_c'] = $load_libraries.include?("Wire") ? p['arduino_root'].join('hardware','libraries','Wire','utility','twi.c') : ''
      @params['asm_files'] = PROJECT_ROOT.join(PROJECT_ROOT).children.select{ |c| c.file? }
            
      e = ERB.new File.read(RAD_LIB.join('templates','makefile.erb'))
      
      File.open("#{build_dir}/Makefile", "w") do |f|
        f << e.result(binding)
      end
    end
    
    def params
      @params ||= YAML.load_file(PROJECT_ROOT.join('config.yml'))
    end
    
    ## match the mcu with the proper board configuration from the arduino board.txt file
    def board_configuration(arduino_root, board_name)
      board_configuration = {}
      File.open(arduino_root.join('hardware','arduino','boards.txt'), "r") do |infile|
      	infile.each_line do |line|
      	  next unless line.chomp =~ /^#{board_name}\.([^=]*)=(.*)$/
      	  board_configuration[$1] = $2
      	end
      end
      board_configuration
    end
      
  end
end