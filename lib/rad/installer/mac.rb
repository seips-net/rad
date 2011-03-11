module Rad::Installer::Mac
  def self.run
    text = <<-MACOS
To install Arduino on MacOS follow the instructions on the Website.
http://arduino.cc/en/Guide/MacOSX
MACOS
    puts text
  end

  def self.install
    #TODO
  end
end

class DarwinInstaller
  def self.install!
    puts "Downloading arduino-0015 for Mac from Arduino.cc"
    File.open("/Applications/arduino-0015.zip", "w") do |file|
      pbar = nil
      file << open("http://arduino.googlecode.com/files/arduino-0015-mac.zip",
      :content_length_proc => lambda {|t|
        if t && 0 < t
          pbar = ProgressBar.new(" Progress", t)
          pbar.file_transfer_mode
        end
      },
      :progress_proc => lambda {|s|
        pbar.set s if pbar
      }).read
      pbar.finish
    end
    puts "Unzipping..."
    `cd /Applications; unzip arduino-0015.zip`
    `rm /Applications/arduino-0015.zip`
    puts "installed Arduino here: /Applications/arduino-0015"
  end
end