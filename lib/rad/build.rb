class Rad::Build
  class << self; attr_accessor :sketch_name end
  def self.run
    
    @sketch_name = ARGV[0]
    raise "Sketchname is missing" unless @sketch_name

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
    # Build vendor/rad:

    FileUtils.mkdir_p "#{@sketch_name}/vendor/rad"
    puts "Successfully created your sketch directory."

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/rad/.", "#{@sketch_name}/vendor/rad"
    puts "Installed RAD into #{@sketch_name}/vendor/rad"
    puts
  end
  
  def self.libraries
    # Build vendor/libraries:
    
    FileUtils.mkdir_p "#{@sketch_name}/vendor/libraries"
    puts "Successfully created your libraries directory."
    
    libs = %W{ AF_XPort AFSoftSerial DS1307 FrequencyTimer2 I2CEEPROM LoopTimer OneWire Servo Stepper SWSerLCDpa SWSerLCDsf Wire }
    libs.each do |lib|
      src = RAD_LIB.join('libraries',lib,'.')
      dest = "#{@sketch_name}/vendor/libraries/#{lib}"
      FileUtils.cp_r src, dest
      puts "Installed #{lib} into #{@sketch_name}/vendor/libraries"
    end
  end

  def self.examples
    # Build examples -- used for basic testing

    FileUtils.mkdir_p "#{@sketch_name}/vendor/libraries"
    puts "Successfully created your examples directory."

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/examples/.", "#{@sketch_name}/examples"
    puts "Installed examples into #{@sketch_name}/examples"
    puts
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
    # Build vendor/plugins:

    FileUtils.mkdir_p "#{@sketch_name}/vendor/plugins"
    puts "Successfully created your plugins directory."

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/plugins/.", "#{@sketch_name}/vendor/plugins"
    puts "Installed Default plugins into #{@sketch_name}/vendor/plugins"
    puts
  end
  
  def self.sketch
    # Add an default sketch directory # needed to run test:compile

    FileUtils.mkdir_p "#{@sketch_name}/#{@sketch_name}"
    puts "Successfully created your default sketch directory."

    FileUtils.touch "#{@sketch_name}/#{@sketch_name}.rb"
    File.open("#{@sketch_name}/#{@sketch_name}.rb", "w") do |file|
      file << <<-EOS
    class #{@sketch_name.split("_").collect{|c| c.capitalize}.join("")} < ArduinoSketch

    # looking for hints?  check out the examples directory
    # example sketches can be uploaded to your arduino with
    # rake make:upload sketch=examples/hello_world
    # just replace hello_world with other examples
    #
    # hello world (replace with your code):

    output_pin 13, :as => :led

    def loop
    blink led, 100
    end

    end
      EOS
    end
    puts "Added #{@sketch_name}/#{@sketch_name}.rb"
  end

  def self.rake_file
    File.open("#{@sketch_name}/Rakefile", 'w') do |file|
      file << <<-EOS
    require 'vendor/rad/init.rb'
      EOS
    end
    puts "Added #{@sketch_name}/Rakefile"
  end
  
  def self.config
    FileUtils.mkdir_p "#{@sketch_name}/config"
    puts "Added #{@sketch_name}/config"
    
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
    puts "Added #{@sketch_name}/config/hardware.yml"
    
    File.open("#{@sketch_name}/config/software.yml", 'w') do |file|
      file << options["software"].to_yaml
    end
    puts "Added #{@sketch_name}/config/software.yml"
  end

  def self.text
    puts "Run 'rake -T' inside your sketch dir to learn how to compile and upload it."

    puts "***************************************************"
    puts "***     Please note: This version supports      ***"
    puts "***            Arduino 15 only!                 ***"
    puts "***                                             ***"
    puts "***      default configuration: diecimila       ***"
    puts "***       to change goto config/hardware        ***"
    puts "***                                             ***"
    puts "***                using usb?                   ***"
    puts "***    don't forget to install the drivers      ***"
    puts "***                                             ***"
    puts "***             for OS X users:                 ***"
    puts "***       upgraded to Snow Leopard?             ***"
    puts "***  don't forget to install the new drivers:   ***"
    puts ""
    puts "http://www.ftdichip.com/Drivers/VCP/MacOSX/UniBin/FTDIUSBSerialDriver_v2_2_14.dmg"
    puts ""
    puts "***       and install the new xcode             ***"
    puts "***                                             ***"
    puts "***   run rad install arduino to upgrade        ***"
    puts "***************************************************"
  end

end