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
      lookup
    end

    def lookup
      @children = []
      Dir.foreach(self.path) do |entry|
        next if (entry == '..' || entry == '.')
        full_path = ::File.join(self.path, entry)
        if ::File.directory?(full_path)
          children.push DirFile.new(self, entry)
        else
          children.push DataFile.new(self, entry)
        end
      end
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

    def initialize path
      @path = path
      @name = ::File.basename(path)
      lookup
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
