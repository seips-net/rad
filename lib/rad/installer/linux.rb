class Rad::Installer::Linux < Rad::Installer::Base
  def self.run
    arduino_url = 'http://arduino.googlecode.com/files/arduino-0022.tgz'
    opt_dir = Pathname.new '/opt'
    arduino_file = opt_dir + arduino_url.split('/').last

    download arduino_url, arduino_file
    #extract arduino_file, opt_dir

    text = <<-TEXT
To install Arduino on Linux follow the instructions on the Website.
http://www.arduino.cc/playground/Learning/Linux
You can find Arduino (not jet extracted) in #{opt_dir} .
Extract it and run the "arduino" script.
TEXT
    puts text

  end
end