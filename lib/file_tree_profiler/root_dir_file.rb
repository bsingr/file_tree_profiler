module FileTreeProfiler
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
end
