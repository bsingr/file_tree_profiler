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

    def inspect
      "<#{self.class} @name=#{name} #path=#{path}>"
    end
  end
end
