module Rad::ArduinoSketch::Base

  def comment_box( content ) #:nodoc:
    out = []
    out << "/" * 74
    out << "// " + content
    out << "/" * 74
    
    return out.join( "\n" )
  end

end
