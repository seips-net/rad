namespace :test do

  desc "iterate through all the sketches in the example directory"
  task :upload => :gather do
    @examples.each {|e| run_tests(e, "upload")}
  end

  task :compile => :gather do

    @examples.each {|e| run_tests(e, "compile")}
  end

  desc "gather all tests"
  task :gather do # => "make:upload" do
    @examples = []
    if ENV['sketch']
      @examples << ENV['sketch']
    else
      Dir.entries( File.expand_path("#{RAD_ROOT}/examples/") ).each do |f|
        @examples << f.split('.').first if (f =~ /\.rb$/)
      end
    end
  end

end