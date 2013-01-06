module FileTreeProfiler
  class Merge
    class Pairing
      EQUAL       = 1
      DIFFERENT   = 2
      ONLY_SOURCE = 3
      ONLY_TARGET = 4

      attr_accessor :status_leaf

      def initialize
        @status_leaf = false
      end

      def add scope, file
        @files ||= {}
        @files[scope] = file
      end

      def source
        @files[:source]
      end

      def target
        @files[:target]
      end

      def name
        any.name
      end

      def relative_path
        any.relative_path
      end

      def parent_relative_path
        if relative_path == '/'
          nil
        else
          ::File.dirname(relative_path)
        end
      end

      def any
        (source || target)
      end

      def status
        @status ||= begin
          if source && target
            if source.checksum == target.checksum
              EQUAL
            else
              DIFFERENT
            end
          elsif source
            ONLY_SOURCE
          else
            ONLY_TARGET
          end
        end
      end

    end
  end
end
