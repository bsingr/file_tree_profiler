require "file_tree_profiler/version"
require 'digest/md5'

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
          lookup_dir(RootDirFile.new(path, ::File.basename(path)))
        else
          raise "profiling data files not possible"
        end
      end
    end

    def lookup_dir dir_file
      Dir.foreach(dir_file.path) do |entry|
        next if (entry == '..' || entry == '.')
        full_path = ::File.join(dir_file.path, entry)
        if ::File.directory?(full_path)
          dir_file << lookup_dir(DirFile.new(dir_file, entry))
        else
          dir_file << DataFile.new(dir_file, entry)
        end
      end
      dir_file
    end

    def size
      @root.size
    end
  end

  class File
    attr_reader :parent, :name

    def initialize parent, name
      @parent = parent
      @name = name
    end

    def path
      ::File.join(parent.path, name)
    end
  end

  class DirFile < File
    EMPTY_CHECKSUM = ::Digest::MD5.hexdigest('/no-children/')
    attr_reader :children

    def initialize *args
      super *args
      @children = []
    end

    def << child
      children.push child
    end

    def empty?
      children.empty?
    end

    def size
      children.inject(1) {|sum, c| sum += c.size; sum }
    end

    def checksum
      @checksum ||= begin
        if empty?
          EMPTY_CHECKSUM
        else
          ::Digest::MD5.hexdigest(children.map(&:checksum).join)
        end
      end
    end
  end

  class RootDirFile < DirFile
    attr_reader :path

    def initialize *args
      super *args
      @path = @parent
      @parent = nil
    end

    def parent
      raise 'root has no parent'
    end
  end

  class DataFile < File
    EMPTY_CHECKSUM = ::Digest::MD5.hexdigest('/no-data/')

    def empty?
      ::File.zero?(path)
    end
    
    def checksum
      @checksum ||= begin
        empty? ? EMPTY_CHECKSUM : ::Digest::MD5.file(path)
      end
    end

    def size
      1
    end
  end

  def self.profile path
    Profile.new path
  end
end
