module FileTreeProfiler
  class Merge
    attr_reader :source_profile, :target_profile, :files

    def initialize source_profile, target_profile
      @source_profile = source_profile
      @target_profile = target_profile
      @files = {}
      merge :source, source_profile.root
      merge :target, target_profile.root
      
      files.each do |relative_path, f|
        if parent_relative_path = f.parent_relative_path
          if parent = files[parent_relative_path]
            f.status_leaf = parent.status != f.status
          end
        end
      end
    end

    def add scope, file
      key = file.relative_path
      files[key] ||= Pairing.new
      files[key].add scope, file
    end

    def merge scope, dir_file
      add scope, dir_file
      dir_file.children.each do |child|
        if child.class == DirFile
          merge scope, child
        else
          add scope, child
        end
      end
    end

    def [](relative_path)
      files[relative_path]
    end

    def size
      files.size
    end
  end
end
