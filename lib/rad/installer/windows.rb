class Rad::Installer::Windows < Rad::Installer::Base

  #  To install Arduino on Windows follow the instructions on the Website. http://arduino.cc/en/Guide/Windows

  def self.run
    arduino_url = 'http://arduino.googlecode.com/files/arduino-0022.zip'
    opt_dir = Pathname.new 'C:/opt'
    arduino_file = opt_dir + arduino_url.split('/').last

    download arduino_url, arduino_file
    extract arduino_file, opt_dir

    text = <<-TEXT
To install Arduino on Windows follow the instructions on the Website.
http://arduino.cc/en/Guide/Windows
You can find Arduino extracted in #{opt_dir}
TEXT
    puts text

  end

end