require_relative '../color'

class ASE
  class Color
    class CMYK
      attr_accessor :c, :m, :y, :k

      def initialize(c=0, m=0, y=0, k=0)
        @c = c
        @m = m
        @y = y
        @k = k
      end

      def read!(file)
        @c, @m, @y, @k = 4.times.map do
          file.read(4).unpack('g')[0]
        end
      end

      def to_rgb
        r = (1 - (@c * (1 - @k) + @k)) * 255
        g = (1 - (@m * (1 - @k) + @k)) * 255
        b = (1 - (@y * (1 - @k) + @k)) * 255

        # Clamp
        r = [0, r, 255].sort[1].to_i
        g = [0, g, 255].sort[1].to_i
        b = [0, b, 255].sort[1].to_i

        RGB.new(r, g, b)
      end

      def to_a
        [@c, @m, @y, @k]
      end
    end
  end
end