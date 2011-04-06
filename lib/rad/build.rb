require 'erb'

class Rad::Build
  class << self; attr_accessor :sketch_name end
  def self.run

    options, parser = OptionParser.parse(ARGV)
    @sketch_name = ARGV[0]
    parser.parse!(["-h"]) unless @sketch_name

    vendor_rad
    libraries
    examples
    test
    plugins
    sketch
    rake_file
    config
    text
  end

  def self.vendor_rad
    FileUtils.mkdir_p "#{@sketch_name}/vendor/rad"
    FileUtils.cp_r RAD_LIB.join('rad'), "#{@sketch_name}/vendor/rad"
  end
  
  def self.libraries
    FileUtils.mkdir_p "#{@sketch_name}/vendor/libraries"

    libs = %W{ AF_XPort AFSoftSerial DS1307 FrequencyTimer2 I2CEEPROM LoopTimer OneWire Servo Stepper SWSerLCDpa SWSerLCDsf Wire }
    libs.each do |lib|
      src = RAD_LIB.join('libraries',lib,'.')
      dest = "#{@sketch_name}/vendor/libraries/#{lib}"
      FileUtils.cp_r src, dest
    end
  end

  def self.examples
    FileUtils.mkdir_p "#{@sketch_name}/vendor/libraries"
    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/examples/.", "#{@sketch_name}/examples"
  end
  
  def self.test
    # Build test -- used testing
    
    # FIXME: this should put the tests into the vendor/tests directory instead.
    
    # FileUtils.mkdir_p "#{@sketch_name}/test"
    # puts "Successfully created your test directory."
    #
    # FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/test/.", "#{@sketch_name}/test"
    # puts "Installed tests into #{@sketch_name}/test"
    # puts
  end

  def self.plugin
    FileUtils.mkdir_p "#{@sketch_name}/vendor/plugins"
    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/plugins/.", "#{@sketch_name}/vendor/plugins"
  end
  
  def self.sketch
    FileUtils.mkdir_p "#{@sketch_name}/#{@sketch_name}"
    FileUtils.touch "#{@sketch_name}/#{@sketch_name}.rb"
    File.open("#{@sketch_name}/#{@sketch_name}.rb", "w") do |file|
      file << ERB.new(File.read(RAD_LIB + 'templates' + 'sketch.erb')).run
    end
  end

  def self.rake_file
    File.open("#{@sketch_name}/Rakefile", 'w') do |file|
      file << ERB.new(File.read(RAD_LIB + 'templates' + 'Rakefile.erb')).run
    end
  end
  
  def self.config
    FileUtils.mkdir_p "#{@sketch_name}/config"
    File.open("#{@sketch_name}/config/hardware.yml", 'w') do |file|
      file << "##############################################################
    # Today's MCU Choices (replace the mcu with your arduino board)
    # atmega8 => Arduino NG or older w/ ATmega8
    # atmega168 => Arduino NG or older w/ ATmega168
    # mini => Arduino Mini
    # bt  => Arduino BT
    # diecimila  => Arduino Diecimila or Duemilanove w/ ATmega168
    # nano  => Arduino Nano
    # lilypad  => LilyPad Arduino
    # pro => Arduino Pro or Pro Mini (8 MHz)
    # atmega328 => Arduino Duemilanove w/ ATmega328
    # mega => Arduino Mega

      "
      file << options["hardware"].to_yaml
    end
    
    File.open("#{@sketch_name}/config/software.yml", 'w') do |file|
      file << options["software"].to_yaml
    end
  end

  def self.text
    puts "Run 'rake -T' inside your sketch dir to learn how to compile and upload it."
    puts "Default configuration: 'diecimila', to change goto config/hardware"
    puts "Don't forget to install the drivers."
    puts "Run rad install to upgrade."
  end

end