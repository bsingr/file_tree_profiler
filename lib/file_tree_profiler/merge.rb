module FileTreeProfiler
  class Merge
    attr_reader :source_profile, :target_profile, :pairings

    def initialize source_profile, target_profile
      @source_profile = source_profile
      @target_profile = target_profile
      @pairings = {}
      merge :source, source_profile.root
      merge :target, target_profile.root
      
      pairings.each do |relative_path, f|
        if parent_relative_path = f.parent_relative_path
          if parent = self[parent_relative_path]
            f.status_leaf = parent.status != f.status
          end
        end
      end
    end

    def add scope, file
      key = file.relative_path
      pairings[key] ||= Pairing.new
      pairings[key].add scope, file
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
      pairings[relative_path]
    end

    def size
      pairings.size
    end
  end
end
