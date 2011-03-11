module Rad::Installer
  def self.run

    case RUBY_PLATFORM
    when /linux/ # Linux
      require RAD_LIB.join('rad','installer','linux')
      Rad::Installer::Linux.run
    when /darwin/ # MacOS
      require RAD_LIB.join('rad','installer','mac')
      Rad::Installer::Mac.run
    when /mingw32/ # Windows
      require RAD_LIB.join('rad','installer','windows')
      Rad::Installer::Windows.run
    else
      raise "Sorry. Your operation system was not detected as one of the supported systems."
    end

  end
end
