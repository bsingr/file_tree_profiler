require 'digest/md5'
require 'file_tree_profiler/version'
require 'file_tree_profiler/file'
require 'file_tree_profiler/data_file'
require 'file_tree_profiler/dir_file'
require 'file_tree_profiler/root_dir_file'

module FileTreeProfiler
  class Profile
    attr_reader :path, :root

    def initialize path
      @path = path
      profile
    end

    def profile
      @root = begin
        if ::File.directory? path
          RootDirFile.new(path)
        else
          raise "profiling data files not possible"
        end
      end
    end

    def size
      @root.size
    end
  end

  def self.profile path
    Profile.new path
  end
end
