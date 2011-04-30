class Rad::Installer::Windows < Rad::Installer::Base

  def self.run
    arduino_url = config['download_file']
    sha1 = config['sha1']
    opt_dir = Pathname.new config['application_dir']
    arduino_file = opt_dir + arduino_url.split('/').last

    download arduino_url, arduino_file
    extract_zip arduino_file, opt_dir

    text = <<-TEXT
To install Arduino on Windows follow the instructions on the Website.
http://arduino.cc/en/Guide/Windows
You can find Arduino extracted in #{opt_dir}
TEXT
    puts text

  end

end