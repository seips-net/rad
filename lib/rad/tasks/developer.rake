require File.expand_path(File.dirname(__FILE__) + "/../init.rb")
require 'ruby_to_ansi_c'

# purpose: compare regex processing for plugin loading across every plugin

C_VAR_TYPES = "unsigned|int|long|double|str|char|byte"

namespace :regex do
    
    desc "compare_plugin_meth"
    task :summary => [:file_list, :plugin_meth_one, :plugin_meth_two ] do
      sh %{diff #{File.expand_path("vendor/rad/tasks/plugin_signatures_one.rb")} #{File.expand_path("vendor/rad/tasks/plugin_signatures_two.rb")} | mate }
      puts "done"
    end
  
    desc "test plugin method gathering"
    task :plugin_meth_one do 
      plugin_signatures = []
      total_sigs = 0
      @plugin_names.each do |name|
        plugin_string = (File.read(File.expand_path("#{RAD_ROOT}/vendor/plugins/#{name}")))  
        puts plugin_string
        puts 
        puts
        # new style regex
        plugin_signatures << plugin_string.scan(/^\s*(((#{PLUGIN_C_VAR_TYPES})\s*)+\w*\(.*\))/)  
        # ^\s*(((#{PLUGIN_C_VAR_TYPES})\s*)+\w*\(.*\)) 
        total_sigs += plugin_signatures.length 
        puts 
        puts "plugin: #{name}" 
        plugin_signatures.each do |sig|
          puts sig
        end
        puts "#{total_sigs} total plugin signatures"
        result = plugin_signatures.join("\n")
        File.open(File.expand_path("vendor/rad/tasks/plugin_signatures_one.rb"), "w"){|f| f << result}
      end
    end
      
      desc "test plugin method gathering"
      task :plugin_meth_two do 
        plugin_signatures = []
        total_sigs = 0
        @plugin_names.each do |name|
          plugin_string = (File.read(File.expand_path("#{RAD_ROOT}/vendor/plugins/#{name}")))  
          puts plugin_string
          puts 
          puts
          # original regex
          plugin_signatures << plugin_string.scan(/^\s((#{PLUGIN_C_VAR_TYPES}).*\(.*\))/)   
          total_sigs += plugin_signatures.length 
          puts 
          puts "plugin: #{name}" 
          plugin_signatures.each do |sig|
            puts sig
          end
          puts "#{total_sigs} total plugin signatures"
          result = plugin_signatures.join("\n")
          File.open(File.expand_path("vendor/rad/tasks/plugin_signatures_two.rb"), "w"){|f| f << result}
        end
      end
  
    desc "gather files needed"
    task :file_list do
      # take another look at this, since if the root directory name is changed, everything breaks
      # perhaps we generate a constant when the project is generated an pop it here or in the init file
      @sketch_directory = File.expand_path("#{File.dirname(__FILE__)}/../../../").split("/").last
      # multiple sketches are possible with rake make:upload sketch=new_sketch
      @test_dir = ""
      if ENV['sketch'] =~ /^examples\//
        # strip the example and set a directory variable
        ENV['sketch'] = ENV['sketch'].gsub(/^examples\//, "")
        @test_dir = "examples/"
      end
      @sketch_class = ENV['sketch'] ? "#{ENV['sketch']}.rb" : "#{@sketch_directory}.rb"
      $sketch_file_location = @test_dir + @sketch_class
      @file_names = []
      @plugin_names = []
      Dir.entries( File.expand_path(RAD_ROOT) ).each do |f|
        if (f =~ /\.rb$/)
          @file_names << f
        end
      end
      Dir.entries( File.expand_path("#{RAD_ROOT}/vendor/plugins/") ).each do |f|
        if (f =~ /\.rb$/)
          @plugin_names << f
        end
      end
    end

  
  
end
