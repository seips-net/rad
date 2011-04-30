# TODO:
#   compilation
#   gather pieces of code we need as strings
#   translate non-loop methods
#   do plugin stuff
#   deal with examples/ exception
#   manage upload process
#   compose_setup should move in here entirely

# require 'arduino_sketch'

class Rad::SketchCompiler
  attr_accessor :path, :body, :klass, :target_dir, :name
  
  def initialize sketch_file
    @path = sketch_file.expand_path
    @body = open(@path).read
    @name = @path.basename('.rb')
    @klass = @name.camelize
    @target_dir = @path.dirname
  end
  
  def build_dir
    "#{self.target_dir}/#{self.name}"
  end

  def create_build_dir! optional_path_prefix=nil
    self.target_dir = optional_path_prefix if optional_path_prefix
    FileUtils.mkdir_p build_dir
  end
  
  def process_constants
    self.body.gsub!("HIGH", "1")
    self.body.gsub!("LOW", "0")
    self.body.gsub!("ON", "1")
    self.body.gsub!("OFF", "0")
  end
  
  def sketch_methods
    self.body.scan(/^\s*def\s.\w*/).collect{ |m| m.gsub(/\s*def\s*/, "") }
  end
  
end