require_relative '../color'

class ASE
  class Color
    class RGB
      attr_accessor :r, :g, :b

      class << self
        def from_rgba(*args)
          args = args.first if args.length == 1
          self.new *args
        end
        alias :from_rgb :from_rgba

        def from_hex(hex)
          self.new *hex
            .gsub('#', '')[0...6]
            .scan(/../)
            .map { |c| c.to_i(16) }
        end
      end

      def initialize(r=0, g=0, b=0)
        @r = r
        @g = g
        @b = b
      end

      def read!(file)
        @r, @g, @b = 3.times.map do |c|
          (file.read(4).unpack('g')[0] * 255).to_i
        end
      end

      def write!(file)
        file.write 'RGB '
        to_a.each { |c| file.write [c.to_f / 255].pack('g') }
      end

      def to_rgb
        self
      end

      def to_a
        [@r, @g, @b]
      end

      def to_css
        "rgba(#{r}, #{g}, #{b}, #{255})"
      end

      def [](i)
        [@r, @g, @b, 255][i]
      end

      def to_hex(incl_hash=true)
        hex = incl_hash ? '#' : ''
        colors = [@r, @g, @b]

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
end