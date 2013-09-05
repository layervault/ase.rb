require_relative '../color'

class ASE
  class Color
    class Gray
      attr_accessor :value

      def initialize(value=0)
        @value = value
      end

      def read!(file)
        @value = file.read(4).reverse.unpack('F')[0]
      end

      def to_rgb
        [rgb_value] * 3
      end

      def to_rgba
        to_rgb + [255]
      end

      private

      def rgb_value
        (@value * 255).round
      end
    end

    class Grey < Gray; end
  end
end