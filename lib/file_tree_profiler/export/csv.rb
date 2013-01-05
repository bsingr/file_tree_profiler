require 'csv'

module FileTreeProfiler
  module Export
    class CSV
      attr_reader :profile, :filename
      def initialize(profile, filename)
        @profile = profile
        @filename = filename
        ::CSV.open("#{filename}.csv", "wb") do |csv|
          profile csv, profile.root
        end
      end

      def write_line csv, file
        csv << [file.class, file.path, file.relative_path, file.name, file.checksum, file.empty?, file.size]
      end

      def profile csv, dir_file
        write_line csv, dir_file
        dir_file.children.each do |child|
          if child.class == DirFile
            profile csv, child
          else
            write_line csv, child
          end
        end
      end
    end
  end
end
