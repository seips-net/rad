require 'rake'

class Rad::Make
  def self.rake_load
    RAD_LIB.join('rad','tasks').children.each do |child|
      load child if child.file? and child.extname == '.rake'
    end
  end
end