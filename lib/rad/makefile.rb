require 'erb'
require 'yaml'

class Rad::Makefile
  class << self
    
    # build the sketch Makefile for the given template based on the values in its software and hardware config files
    def compose_for_sketch(build_dir)
      params = hardware_params.merge software_params
      board_config = board_configuration(@software_params['arduino_root'], @hardware_params['mcu'])
      params = params.merge board_config
      params['target'] = build_dir.split("/").last
           
      params['libraries_root'] = PROJECT_ROOT.join('vendor','libraries')
      params['libraries'] = $load_libraries # load only libraries used 
      
      # needed along with ugly hack of including another copy of twi.h in wire, when using the Wire.h library
      params['twi_c'] = $load_libraries.include?("Wire") ? params['arduino_root'].join('hardware','libraries','Wire','utility','twi.c') : ''
      
      params['asm_files'] = PROJECT_ROOT.join(PROJECT_DIR_NAME).entries.select{|e| e =~ /\.S/}
            
      e = ERB.new File.read(RAD_LIB.join('templates','makefile.erb'))
      
      File.open("#{build_dir}/Makefile", "w") do |f|
        f << e.result(binding)
      end
    end
        
    def hardware_params
      @hardware_params ||= YAML.load_file(PROJECT_ROOT.join('config','hardware.yml'))
    end
      
    def software_params
      @software_params ||= YAML.load_file(PROJECT_ROOT.join('config','software.yml'))
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