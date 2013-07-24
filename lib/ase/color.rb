# Nice little wrapper that lets us easily perform some functions on a
# given color.
class ASE
  class Color
    class << self
      def from_rgba(*args)
        args = args.first if args.length == 1
        self.new *args
      end
      alias :from_rgb :from_rgba

      def from_hex(hex)
        self.new *hex.gsub('#', '').scan(/../).map { |c| c.to_i(16) }
      end
    end

    attr_accessor :r, :g, :b, :a

    # We always internally store the color as RGBA.
    def initialize(r, g, b, a = 255)
      @r = r
      @g = g
      @b = b
      @a = a
    end

    def to_rgba
      [@r, @g, @b, @a]
    end

    def to_rgb
      [@r, @g, @b]
    end

    def to_css
      "rgba(#{r}, #{g}, #{b}, #{a})"
    end

    def [](i)
      [@r, @g, @b, @a][i]
    end

    def to_hex(incl_hash=true, incl_alpha=false)
      hex = incl_hash ? '#' : ''
      colors = [@r, @g, @b]
      colors << @a if incl_alpha

      colors.each do |c| 
        color = c.to_s(16)
        if c < 16
          hex << "0#{color}"
        else
          hex << color
        end
      end

      return hex
    end
    alias :to_s :to_hex
  end
end