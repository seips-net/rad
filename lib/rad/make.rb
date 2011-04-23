require 'rake'

class Rad::Make
  def self.rake_load
    task_dir = RAD_LIB.join('rad','tasks')
    task_dir.entries.each do |entry|
      # puts entry.realpath return wrong path #todo verify and write bug report, #todo filter by file extension
      task_entry = task_dir + entry
      load task_entry if task_entry.file?
    end
  end
end