module Rad::Arduino::Sketch::Base

  # Add a comment box like this:
  # ///////////////...///////////////
  # // My Comment                  //
  # ///////////////...///////////////

  def comment_box( content )
    out = []
    out << "/" * 80
    out << "// " + content.ljust(74, ' ') + " //"
    out << "/" * 80
    
    return out.join( "\n" )
  end

end
