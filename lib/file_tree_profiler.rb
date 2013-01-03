require 'digest/md5'
require 'file_tree_profiler/version'
require 'file_tree_profiler/file'
require 'file_tree_profiler/data_file'
require 'file_tree_profiler/dir_file'
require 'file_tree_profiler/profile'
require 'file_tree_profiler/export/csv'

module FileTreeProfiler
  def self.profile path
    Profile.new path
  end

  def self.csv profile, basename
    Export::CSV.new profile, basename
  end

  end
end
