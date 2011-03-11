module Rad::Installer::Windows
  def self.run
    text = <<-WINDOWS
To install Arduino on Windows follow the instructions on the Website.
http://arduino.cc/en/Guide/Windows
WINDOWS
    puts text
  end

  def self.install
    #TODO
  end
end