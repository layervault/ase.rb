require_relative '../color'

class ASE
  class Color
    class Gray
      attr_accessor :value

      def initialize(value=0)
        @value = value
      end

      def read!(file)
        @value = file.read(4).unpack('g')[0].round(4)
      end

      def write!(file)
        file.write('Gray')
        to_a.each { |c| file.write [c].pack('g') }
      end

      def to_rgb
        RGB.new(*([rgb_value] * 3))
      end

      def to_a
        [@value]
      end

      private

      def rgb_value
        (@value * 255).to_i
      end
    end

    class Grey < Gray; end
  end
end