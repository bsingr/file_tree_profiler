module FileTreeProfiler
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
end
