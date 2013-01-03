require 'digest/md5'
require 'file_tree_profiler/version'
require 'file_tree_profiler/file'
require 'file_tree_profiler/data_file'
require 'file_tree_profiler/dir_file'
require 'file_tree_profiler/profile'

module FileTreeProfiler
  def self.profile path
    Profile.new path
  end

  end

  end
end
