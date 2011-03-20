module Rad::Installer::Windows
  def self.run
    url = 'http://arduino.googlecode.com/files/arduino-0022.zip'
    file = 'C:\opt\arduino-0022.zip'
    download url, file
    exit
    extract file
    exit
    download_file
    text = <<-WINDOWS
To install Arduino on Windows follow the instructions on the Website.
http://arduino.cc/en/Guide/Windows
WINDOWS
    puts text
  end

  def self.download(from_url, to_file)

    open(from_url, 'r', :read_timeout=>600) {|f|
      File.open(to_file,"wb") do |file|
        file.puts f.read
      end
    }
    
  end

  def self.extract(file)

  end

end