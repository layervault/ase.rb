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
        @c, @m, @y, @k = file.read(16).scan(/.{1,4}/).map do |c|
          c.reverse.unpack('F')[0]
        end
      end

      def to_rgb
        r = 1 - (c * (1 - k) + k) * 255
        g = 1 - (m * (1 - k) + k) * 255
        b = 1 - (y * (1 - k) + k) * 255

        # Clamp
        r = [0, r, 255].sort[1]
        g = [0, g, 255].sort[1]
        b = [0, b, 255].sort[1]

        [r, g, b]
      end

      def to_rgba
        to_rgb + [255]
      end
    end
  end
end