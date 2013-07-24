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
    alias :add_color :add

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

    def method_missing(method, *args, &block)
      if @colors.has_key?(method.to_s)
        return @colors[method.to_s]
      end

      super
    end
  end
end