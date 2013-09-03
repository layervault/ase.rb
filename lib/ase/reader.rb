class ASE
  module Reader
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module ClassMethods
      def from_file(file)
        doc = ASE.new(file)
        doc.read!

        return doc
      end
    end

    module InstanceMethods
      def from_file(file)
        @file = file
        read!
      end

      def read!
        raise "Must specify an output file" if @file.nil?
        @file = File.new(@file, 'rb')

        # Signature and version, who cares?
        # Okay maybe we should validate this in the future.
        @file.seek 8, IO::SEEK_CUR

        block_count = @file.read_ulong
        
        read_palette until @file.eof?

        @file.close
      end

      private

      def read_palette
        block_start = @file.read_ushort

        if block_start == 0xC001
          title_block_size = @file.read_ulong
          title = @file.read_string
        else
          # There is no palette. Instead there is a list of colors and
          # some kind of "default" palette.
          title = :default
          @file.seek -2, IO::SEEK_CUR
        end

        palette = Palette.new(title)
        
        # Read the colors
        loop do
          color_start = @file.read_ushort
          break if color_start == 0xC002

          color_size = @file.read_ulong
          color_name = @file.read_string
          color_mode = @file.read(4)

          r, g, b = @file.read(12).scan(/.{1,4}/).map do |c|
            (c.reverse.unpack('F')[0] * 255).to_i
          end

          palette.add color_name, Color.new(r, g, b)

          # Null byte
          @file.seek 2, IO::SEEK_CUR
        end

        # Group end block
        @file.seek 4, IO::SEEK_CUR
        
        add_palette palette
        return true
      end
    end
  end
end