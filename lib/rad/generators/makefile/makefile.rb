require 'erb'
require 'yaml'

class Makefile
  class << self
    
    # build the sketch Makefile for the given template based on the values in its software and hardware config files
    def compose_for_sketch(build_dir)
      params = hardware_params.merge software_params
      board_config = board_configuration(@software_params['arduino_root'], @hardware_params['mcu'])
      params.merge board_config
      params['target'] = build_dir.split("/").last
           
      params['libraries_root'] = "#{File.expand_path(RAD_ROOT)}/vendor/libraries"
      params['libraries'] = $load_libraries # load only libraries used 
      
      # needed along with ugly hack of including another copy of twi.h in wire, when using the Wire.h library
      params['twi_c'] = $load_libraries.include?("Wire") ? "#{params['arduino_root']}/hardware/libraries/Wire/utility/twi.c" : "" 
      
      params['asm_files'] = Dir.entries( File.expand_path(RAD_ROOT) + "/" + PROJECT_DIR_NAME ).select{|e| e =~ /\.S/}            
            
      e = ERB.new File.read("#{File.dirname(__FILE__)}/makefile.erb")
      
      File.open("#{build_dir}/Makefile", "w") do |f|
        f << e.result(binding)
      end
    end
        
    def hardware_params
      return @hardware_params if @hardware_params
      return @hardware_params = YAML.load_file( "#{RAD_ROOT}/config/hardware.yml")
    end
      
    def software_params
      return @software_params if @software_params
      return @software_params = YAML.load_file( "#{RAD_ROOT}/config/software.yml" )
    end
    
    ## match the mcu with the proper board configuration from the arduino board.txt file
    def board_configuration(arduino_root, board_name)
      board_configuration = {}
      File.open("#{arduino_root}/hardware/boards.txt", "r") do |infile|
      	while (line = infile.gets)
      		if line[0, board_name.length] == board_name
            key_value = line[board_name.length + 1, line.length - board_name.length].split("=")
      		  board_configuration[key_value[0]] = key_value[1].split("\n")[0]
      	  end
      	end
      end
      board_configuration
    end
      
  end
end