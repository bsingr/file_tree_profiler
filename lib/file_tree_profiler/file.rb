module FileTreeProfiler
  class File
    attr_reader :parent, :name

    def initialize parent, name
      @parent = parent
      @name = name
    end

    def path
      ::File.join(parent.path, name)
    end

    def relative_path
      if parent.respond_to? :parent
        ::File.join(parent.relative_path, name)
      else
        '/'
      end
    end

    def inspect
      "<#{self.class} @name=#{name} #path=#{path}>"
    end
  end
end
