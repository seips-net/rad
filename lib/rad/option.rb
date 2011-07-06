require 'optparse'

class Rad::Option
  
  def self.parse
    
    # defaults
    options = {
      "serial_port"     => '/dev/tty.usbserial*',
      "mcu"             => "atmega168",
      "physical_reset"  => false,
      "arduino_root"    => "/Applications/arduino-0015"  
    }
    
    opts = OptionParser.new do |opts|
      
      opts.banner = "Usage: #{File.basename($0)} <sketch_dir_name> <options for config>"
      
      opts.on(
        "-p",
        "--port [SERIAL PORT]",
        "Path to your serial port",
        "   (default: #{options['serial_port']})"
      ) do |port|  
        options["serial_port"] = port if port
      end
      
      opts.on(
        "-m",
        "--mcu [PROCESSOR TYPE]",
        "Type of processor on your board",
        "   (default: #{options['mcu']})"
      ) do |port|
        options["mcu"] = mcu if mcu
      end
      
      opts.on("-r",
        "--reset [RESET REQUIRED]",
        "Require a hardware reset before uploading?",
        "   (default: #{options['physical_reset']})"
      ) do |no_reset|
        options["physical_reset"] = true unless no_reset
      end
      
      opts.on(
        "-a",
        "--arduino [ARDUINO DIR]",
        "Path to your Arduino install",
        "   (default: #{options['arduino_root']})"
      ) do |arduino|
        options["arduino_root"] = arduino if arduino
      end
      
      opts.on(
        "-v",
        "--version",
        "RAD version number",
        "   (#{Rad::VERSION::STRING})"
      ) do
        puts Rad::VERSION::STRING
        exit
      end
      
      opts.on_tail(
        "-h",
        "--help",
        "Show this message"
      ) do
        puts opts
        exit
      end
    end
    
    opts.parse!(ARGV)
    [options, opts]
  end
  
end
