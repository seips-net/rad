namespace :make do

  desc "compile the sketch and then upload it to your Arduino board"
  task :upload => :compile do
    if Rad::Makefile.hardware_params['physical_reset']
      puts "Reset the Arduino and hit enter.\n==If your board doesn't need it, you can turn off this prompt in config/software.yml=="
      STDIN.gets.chomp
    end
    sh %{cd #{@sketch.build_dir}; #{@make} upload}
  end

  desc "generate a makefile and use it to compile the .cpp"
  task :compile => [:clean_sketch_dir, "build:sketch"] do # should also depend on "build:sketch"
    Rad::Makefile.compose_for_sketch( @sketch.build_dir )

    # not allowed? sh %{export PATH=#{Rad::Makefile.software_params[:arduino_root]}/tools/avr/bin:$PATH}
    sh %{cd #{@sketch.build_dir}; #{@make} depend; #{@make}}
  end

  desc "generate a makefile and use it to compile the .cpp using the current .cpp file"
  task :compile_cpp => ["build:sketch_dir", "build:gather_required_plugins", "build:plugin_setup", "build:setup", :clean_sketch_dir] do # should also depend on "build:sketch"
    Rad::Makefile.compose_for_sketch( @sketch.build_dir )
    # not allowed? sh %{export PATH=#{Rad::Makefile.software_params[:arduino_root]}/tools/avr/bin:$PATH}
    sh %{cd #{@sketch.build_dir}; #{@make} depend; #{@make}}
  end

  desc "generate a makefile and use it to compile the .cpp and upload it using current .cpp file"
  task :upload_cpp => ["build:sketch_dir", "build:gather_required_plugins", "build:plugin_setup", "build:setup", :clean_sketch_dir] do # should also depend on "build:sketch"
    Rad::Makefile.compose_for_sketch( @sketch.build_dir )
    # not allowed? sh %{export PATH=#{Rad::Makefile.software_params[:arduino_root]}/tools/avr/bin:$PATH}
    sh %{cd #{@sketch.build_dir}; #{@make} depend; #{@make} upload}
  end

  task :clean_sketch_dir => ["build:file_list", "build:sketch_dir"] do
    @sketch.build_dir.children.each do |c|
      c.delete unless c.basename == @sketch.name.to_s + '.cpp'
    end
  end

end