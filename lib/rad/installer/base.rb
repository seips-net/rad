require 'fileutils'
require 'zip/zip'

class Rad::Installer::Base

  def self.download(from_url, to_file)
    puts "Downloading from '#{from_url}' to '#{to_file}' ..."
    open(from_url, 'r', :read_timeout=>600) {|f|
      File.open(to_file,"wb") do |file|
        file.puts f.read
      end
    }
  end

  # bug in rubyzip hope to be fixed in 0.9.5
  # https://github.com/aussiegeek/rubyzip/pull/1
  def self.extract_zip(from_file, to_dir)
    extract_path = to_dir + from_file.basename('.zip')
    Zip::ZipFile.open(from_file) { |zip_file|
      zip_file.each { |f|
        f_path=File.join(extract_path, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      }
    }
  end

end
