class ASE
  class Palette
    attr_accessor :name, :colors

    def initialize(name)
      @name = name
      @colors = {}
    end

    def add(name, color)
      @colors[name] = color
    end
    alias :[]= :add

    def remove(name)
      @colors.delete(name)
    end

    def [](i)
      @colors[i]
    end

    def length
      @colors.length
    end
    alias :size :length
  end
end