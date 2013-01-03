module FileTreeProfiler
  class DirFile < File
    EMPTY_CHECKSUM = ::Digest::MD5.hexdigest('/no-children/').freeze
    attr_reader :children

    def initialize *args
      super *args
      walk
    end

    # collects all children as DirFile or DataFile objects
    # and is invoked on each collected DirFile object
    def walk
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

    # checksum generated using concatenated checksums of all children
    def checksum
      @checksum ||= begin
        if empty?
          EMPTY_CHECKSUM
        else
          ::Digest::MD5.hexdigest(children.map(&:checksum).join)
        end
      end.to_s
    end
  end
end
