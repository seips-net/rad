require 'optparse'

class OptionParser #:nodoc:

  def self.parse(args)
    # defaults

    options = {
                "hardware" => {
                  "serial_port"       => '/dev/tty.usbserial*',
                  "mcu"               => "atmega168",
                  "physical_reset"    => false
                },
                "software" => {
                  "arduino_root"      => "/Applications/arduino-0015"
                }
              }

    opts = OptionParser.new do |opts|

    opts.banner = "Usage: #{File.basename($0)} <sketch_dir_name> <options for config>"

    opts.on("-p", "--port [SERIAL PORT]",
            "Path to your serial port",
            "   (default: #{options['hardware']['serial_port']})") do |port|

      options["hardware"]["serial_port"] = port if port
    end

    opts.on("-m", "--mcu [PROCESSOR TYPE]",
          "Type of processor on your board",
          "   (default: #{options['hardware']['mcu']})") do |port|

      options["hardware"]["serial_port"] = port if port
    end

    opts.on("-r", "--reset [RESET REQUIRED]",
            "Require a hardware reset before uploading?",
            "   (default: #{options['hardware']['physical_reset']})") do |no_reset|
      options["hardware"]["physical_reset"] = true unless no_reset
    end

    opts.on("-a", "--arduino [ARDUINO DIR]",
            "Path to your Arduino install",
            "   (default: #{options['software']['arduino_root']})") do |arduino|
      options["software"]["arduino_root"] = arduino if arduino
    end

    opts.on("-v", "--version",
            "RAD version number",
            "   (#{Rad::VERSION::STRING})") do
      puts Rad::VERSION::STRING
      exit
    end

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
  end

  opts.parse!(args)
    [options, opts]
  end

end