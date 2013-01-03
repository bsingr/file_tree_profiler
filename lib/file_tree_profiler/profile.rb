module FileTreeProfiler
  class Profile
    attr_reader :path, :root

    # @param [String] full_path of the directory
    def initialize full_path
      raise ArgumentError, "Not a directory - #{full_path}" \
        unless ::File.directory?(full_path)
      dir_name = ::File.basename(full_path)
      @path = full_path.gsub(::File.join('', dir_name), '')
      @root = DirFile.new(self, dir_name)
    end

    def size
      root.size
    end

    def checksum
      root.checksum
    end
  end
end
