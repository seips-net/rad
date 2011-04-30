require 'erb'
require 'ostruct'

class Rad::Build
  class << self
    attr_accessor :sketch_name, :options
  end

  def self.run(sketch_name, options)
    @sketch_name = sketch_name
    @options = options

    libraries
    examples
    test
    plugins
    sketch
    rake_file
    config
    text
  end
  
  def self.libraries
    FileUtils.mkdir_p "#{@sketch_name}/vendor/libraries"
    application_dir = Pathname.new( $config['installer'][$config['os']]['application_dir'] )
    src = application_dir.join($config['version'],'libraries')
    dest = "#{@sketch_name}/vendor"
    FileUtils.cp_r src, dest
  end

  def self.examples
    FileUtils.mkdir_p "#{@sketch_name}/examples"
    FileUtils.cp_r RAD_LIB.join('examples'), "#{@sketch_name}/"
  end
  
  def self.test
    # Build test -- used testing
    
    # FIXME: this should put the tests into the vendor/tests directory instead.
    
    # FileUtils.mkdir_p "#{@sketch_name}/test"
    # puts "Successfully created your test directory."
    #
    # FileUtils.cp_r "#{File.dirname(__FILE__)}/../lib/test/.", "#{@sketch_name}/test"
    # puts "Installed tests into #{@sketch_name}/test"
    # puts
  end

  def self.plugins
    FileUtils.mkdir_p "#{@sketch_name}/vendor/plugins"
    FileUtils.cp_r RAD_LIB.join('plugins'), "#{@sketch_name}/vendor"
  end
  
  def self.sketch
    FileUtils.mkdir_p "#{@sketch_name}/#{@sketch_name}"
    FileUtils.touch "#{@sketch_name}/#{@sketch_name}.rb"
    #todo dry and use to_camelcase
    sketch_name_cc = @sketch_name.split("_").collect{|c| c.capitalize}.join("")
    template = File.read(RAD_LIB + 'templates' + 'sketch.erb')
    erb = ERB.new(template)
    File.open("#{@sketch_name}/#{@sketch_name}.rb", "w") do |file|
      file.write erb.result(binding)
    end
  end

  def self.rake_file
    FileUtils.touch "#{@sketch_name}/Rakefile"
    template = File.read(RAD_LIB + 'templates' + 'Rakefile.erb')
    erb = ERB.new(template)
    File.open("#{@sketch_name}/Rakefile", 'w') do |file|
      file.write erb.result(binding)
    end
  end
  
  def self.config
    FileUtils.mkdir_p "#{@sketch_name}/config"

    FileUtils.touch "#{@sketch_name}/config/hardware.yml"
    FileUtils.touch "#{@sketch_name}/config/software.yml"

    hardware = @options["hardware"].to_yaml
    software = @options["software"].to_yaml

    template = File.read(RAD_LIB + 'templates' + 'config_hardware.erb')
    erb = ERB.new(template)
    File.open("#{@sketch_name}/config/hardware.yml", 'w') do |file|
      file.write erb.result(binding)
    end

    template = File.read(RAD_LIB + 'templates' + 'config_software.erb')
    erb = ERB.new(template)
    File.open("#{@sketch_name}/config/software.yml", 'w') do |file|
      file.write erb.result(binding)
    end
  end

  def self.text
    puts "Run 'rake -T' inside your sketch dir to learn how to compile and upload it."
    puts "Default configuration: 'diecimila', to change goto config/hardware"
    puts "Don't forget to install the drivers."
    puts "Run rad install to upgrade."
  end

end