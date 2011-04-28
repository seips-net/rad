namespace :build do

  desc "actually build the sketch"
  task :sketch => [:file_list, :sketch_dir, :gather_required_plugins, :plugin_setup, :setup] do
    c_methods = []
    sketch_signatures = []
    # until we better understand RubyToC let's see what's happening on errors
    @sketch.sketch_methods.each do |meth|
      # use the shiny new RubyToC  version
      raw_rtc_meth = Rad::Ruby2c::Processor.translate(@sketch.path, @sketch.klass.intern, meth.intern)
      puts "Translator Error: #{raw_rtc_meth.inspect}" if raw_rtc_meth =~ /\/\/ ERROR:/
      c_methods << raw_rtc_meth unless meth == "setup"
      # treat the setup method differently
      @additional_setup = [] if meth == "setup"
      raw_rtc_meth.each {|m| @additional_setup << ArduinoSketch.add_to_setup(m) } if meth == "setup"
    end
    c_methods.each {|meth| sketch_signatures << "#{meth.scan(/^\w*\s?\*?\n.*\)/)[0].gsub("\n", " ")};" }
    clean_c_methods = []
    # remove external variables that were previously injected
    c_methods.each { |meth| clean_c_methods << ArduinoSketch.post_process_ruby_to_c_methods(meth) }
    c_methods_with_timer = clean_c_methods.join.gsub(/loop\(\)\s\{/,"loop() {")
    # last chance to add/change setup
    @setup[2] << sketch_signatures.join("\n") unless sketch_signatures.empty?
    # add special setup method to existing setup if present
    if @additional_setup
      @setup[2] << "void additional_setup();" # declaration
      @setup[4] << "\tadditional_setup();" # call from setup
      @setup[5] << @additional_setup.join("") #
    end
    result = "#{@setup.join( "\n" )}\n#{c_methods_with_timer}\n"
    File.open("#{@sketch.build_dir}/#{@sketch.name}.cpp", "w"){|f| f << result}
  end

  # needs to write the library include and the method signatures
  desc "build setup function"
  task :setup do
    Kernel.const_set @sketch.klass, Class.new(ArduinoSketch)

    @@as = Rad::ArduinoSketch::HardwareLibrary.new

    delegate_methods = @@as.methods - Object.new.methods
    delegate_methods.reject!{|m| m == "compose_setup"}

    delegate_methods.each do |meth|
       constantize(@sketch.klass).module_eval <<-CODE
       def self.#{meth}(*args)
       @@as.#{meth}(*args)
       end
       CODE
    end
    # allow variable declaration without quotes: @foo = int
    ["long","unsigned","int","byte","short"].each do |type|
      constantize(@sketch.klass).module_eval <<-CODE
       def self.#{type}
        return "#{type}"
       end
       CODE
    end

    @sketch.process_constants

    eval ArduinoSketch.pre_process(@sketch.body)
    @@as.process_external_vars(constantize(@sketch.klass))
    @setup = @@as.compose_setup
  end

  desc "add plugin methods"
  task :plugin_setup do
    $plugins_to_load.each do |name|
       klass = name.camelize
       puts klass

       eval "class #{klass} < ArduinoPlugin; end;"

       @@ps = ArduinoPlugin.new
       plugin_delegate_methods = @@ps.methods - Object.new.methods
       plugin_delegate_methods.reject!{|m| m == "compose_setup"}

       plugin_delegate_methods.each do |meth|
         constantize(klass).module_eval <<-CODE
         def self.#{meth}(*args)
           @@ps.#{meth}(*args)
         end
         CODE
       end

      ArduinoPlugin.process(File.read(RAD_LIB.join('plugins', (name + '.rb'))))

    end
    @@no_plugins = ArduinoPlugin.new if @plugin_names.empty?
  end

  desc "determine which plugins to load based on use of methods in sketch"
  task :gather_required_plugins do
    @plugin_names.each do |name|
      ArduinoPlugin.check_for_plugin_use(@sketch.body, File.read(name), name.basename('.rb').to_s )
    end
    puts "#{$plugins_to_load.length} of #{$plugin_methods_hash.length} plugins is/are being loaded:  #{$plugins_to_load.join(", ")}"
  end

  desc "setup target directory named after your sketch class"
  task :sketch_dir => [:file_list] do
    @sketch.create_build_dir!
  end

  task :file_list do
    raise "There is no directory #{PROJECT_ROOT}." unless PROJECT_ROOT.directory?

    sketch_dir_name = PROJECT_ROOT.basename
    sketch_file =  PROJECT_ROOT + (sketch_dir_name.to_s + '.rb')

    raise 'Directory is not containing a .rb sketch file with name of the directory.' unless sketch_file.file?

    @sketch = Rad::SketchCompiler.new sketch_file
    
    @plugin_names = []

    RAD_LIB.join('plugins').children.each do |child|
      @plugin_names << child if child.file? and child.extname == '.rb'
    end
  end
end