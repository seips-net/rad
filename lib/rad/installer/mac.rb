class Rad::Installer::Mac < Rad::Installer::Base

  def self.run
    arduino_url = config['download_file']
    sha1 = config['sha1']
    opt_dir = Pathname.new config['application_dir']
    arduino_file = opt_dir + arduino_url.split('/').last

    download arduino_url, arduino_file
    #TODO how to install on arduino
    #extract arduino_file, opt_dir

    text = <<-TEXT
To install Arduino on Mac OS X follow the instructions on the Website.
http://arduino.cc/en/Guide/MacOSX
You can find Arduino (not jet extracted) in #{opt_dir}
TEXT
    puts text

  end
end