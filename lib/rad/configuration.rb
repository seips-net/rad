require 'yaml'

class Rad::Configuration
  def self.run
    load_config
    detect_os
  end

  def self.load_config
    $config = YAML.load_file(RAD_LIB.join('config.yml'))
  end

  def self.detect_os
    os = ''
    case RUBY_PLATFORM
    when /linux/ # Linux
      os = "linux"
    when /darwin/ # MacOS
      os = "mac"
    when /mingw32/ # Windows
      os = "windows"
    else
      raise "Sorry. Your operation system was not detected as one of the supported systems."
    end
    $config['os'] = os
  end

end
