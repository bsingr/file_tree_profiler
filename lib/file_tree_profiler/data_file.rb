module FileTreeProfiler

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
end
