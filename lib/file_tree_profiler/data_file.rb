module FileTreeProfiler
  class DataFile < File
    EMPTY_CHECKSUM = ::Digest::MD5.hexdigest('/no-data/').freeze

    def empty?
      ::File.zero?(path)
    end
    
    def checksum
      @checksum ||= begin
        empty? ? EMPTY_CHECKSUM : ::Digest::MD5.file(path)
      end.to_s
    rescue Errno::ELOOP => e
      puts "path=#{path} is a circular ref"
    end

    def size
      1
    end
  end
end
