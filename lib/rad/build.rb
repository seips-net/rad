module Rad::Build
  def run
    # Handle options:
    options, parser = OptionParser.parse(ARGV)
    sketch_name = ARGV[0]
    parser.parse!(["-h"]) unless sketch_name


    # Build vendor/rad:

    FileUtils.mkdir_p "#{sketch_name}/vendor/rad"
    puts "Successfully created your sketch directory."

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/rad/.", "#{sketch_name}/vendor/rad"
    puts "Installed RAD into #{sketch_name}/vendor/rad"
    puts

    # Build vendor/libraries:

    FileUtils.mkdir_p "#{sketch_name}/vendor/libraries"
    puts "Successfully created your libraries directory."

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/AF_XPort/.", "#{sketch_name}/vendor/libraries/AF_XPort"
    puts "Installed AF_XPort into #{sketch_name}/vendor/libraries"
    puts

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/AFSoftSerial/.", "#{sketch_name}/vendor/libraries/AFSoftSerial"
    puts "Installed AFSoftSerial into #{sketch_name}/vendor/libraries"
    puts

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/DS1307/.", "#{sketch_name}/vendor/libraries/DS1307"
    puts "Installed DS1307 into #{sketch_name}/vendor/libraries"
    puts

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/FrequencyTimer2/.", "#{sketch_name}/vendor/libraries/FrequencyTimer2"
    puts "Installed FrequencyTimer2 into #{sketch_name}/vendor/libraries"
    puts

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/I2CEEPROM/.", "#{sketch_name}/vendor/libraries/I2CEEPROM"
    puts "Installed I2CEEPROM into #{sketch_name}/vendor/libraries"
    puts

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/LoopTimer/.", "#{sketch_name}/vendor/libraries/LoopTimer"
    puts "Installed LoopTimer into #{sketch_name}/vendor/libraries"
    puts

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/OneWire/.", "#{sketch_name}/vendor/libraries/OneWire"
    puts "Installed OneWire into #{sketch_name}/vendor/libraries"
    puts

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/Servo/.", "#{sketch_name}/vendor/libraries/Servo"
    puts "Installed Servo into #{sketch_name}/vendor/libraries"
    puts

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/Stepper/.", "#{sketch_name}/vendor/libraries/Stepper"
    puts "Installed Stepper into #{sketch_name}/vendor/libraries"
    puts

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/SWSerLCDpa/.", "#{sketch_name}/vendor/libraries/SWSerLCDpa"
    puts "Installed SWSerLCDpa into #{sketch_name}/vendor/libraries"
    puts

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/SWSerLCDsf/.", "#{sketch_name}/vendor/libraries/SWSerLCDsf"
    puts "Installed SWSerLCDsf into #{sketch_name}/vendor/libraries"
    puts

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/libraries/Wire/.", "#{sketch_name}/vendor/libraries/Wire"
    puts "Installed Wire into #{sketch_name}/vendor/libraries"
    puts

    # Build examples -- used for basic testing

    FileUtils.mkdir_p "#{sketch_name}/vendor/libraries"
    puts "Successfully created your examples directory."

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/examples/.", "#{sketch_name}/examples"
    puts "Installed examples into #{sketch_name}/examples"
    puts

    # Build test -- used testing

    # FIXME: this should put the tests into the vendor/tests directory instead.

    # FileUtils.mkdir_p "#{sketch_name}/test"
    # puts "Successfully created your test directory."
    #
    # FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/test/.", "#{sketch_name}/test"
    # puts "Installed tests into #{sketch_name}/test"
    # puts

    # Build vendor/plugins:

    FileUtils.mkdir_p "#{sketch_name}/vendor/plugins"
    puts "Successfully created your plugins directory."

    FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/plugins/.", "#{sketch_name}/vendor/plugins"
    puts "Installed Default plugins into #{sketch_name}/vendor/plugins"
    puts

    # Add an default sketch directory # needed to run test:compile

    FileUtils.mkdir_p "#{sketch_name}/#{sketch_name}"
    puts "Successfully created your default sketch directory."

    # Build sketch files, etc.:

    FileUtils.touch "#{sketch_name}/#{sketch_name}.rb"
    File.open("#{sketch_name}/#{sketch_name}.rb", "w") do |file|
    file << <<-EOS
    class #{sketch_name.split("_").collect{|c| c.capitalize}.join("")} < ArduinoSketch

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
    puts "Added #{sketch_name}/#{sketch_name}.rb"

    File.open("#{sketch_name}/Rakefile", 'w') do |file|
    file << <<-EOS
    require 'vendor/rad/init.rb'
    EOS
    end
    puts "Added #{sketch_name}/Rakefile"

    FileUtils.mkdir_p "#{sketch_name}/config"
    puts "Added #{sketch_name}/config"

    File.open("#{sketch_name}/config/hardware.yml", 'w') do |file|
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
    puts "Added #{sketch_name}/config/hardware.yml"

    File.open("#{sketch_name}/config/software.yml", 'w') do |file|
    file << options["software"].to_yaml
    end
    puts "Added #{sketch_name}/config/software.yml"

    puts
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