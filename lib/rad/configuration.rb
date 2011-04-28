require 'yaml'

PLUGIN_C_VAR_TYPES = %w{ int void unsigned long short uint8_t static byte char* uint8_t }

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
