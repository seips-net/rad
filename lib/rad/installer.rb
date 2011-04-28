class Rad::Installer
  def self.run

    case RUBY_PLATFORM
    when /linux/ # Linux
      Rad::Installer::Linux.run

    when /darwin/ # MacOS
      Rad::Installer::Mac.run

    when /mingw32/ # Windows
      Rad::Installer::Windows.run

    else
      raise "Sorry. Your operation system was not detected as one of the supported systems."
    end

  end
end
