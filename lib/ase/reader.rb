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
        
        @palette = Palette.new(:default)
        read_section until @file.eof?

        @file.close
      end

      private

      def read_section
        block_start = @file.read_ushort

        case block_start
        when 0xC001 then start_palette
        when 1      then read_color
        when 0xC002 then end_palette
        end
      end

      def start_palette
        title_block_size = @file.read_ulong
        title = @file.read_string

        @palette = Palette.new(title)
      end

      def end_palette
        # Group end block
        @file.seek 4, IO::SEEK_CUR
        add_palette @palette

        @palette = Palette.new(:default)
      end

      def read_color
        color_size = @file.read_ulong
        color_name = @file.read_string
        color_mode = @file.read(4)

        color = Color.factory(color_mode)
        color.read!(@file)

        @palette.add color_name, color

        # Null byte
        @file.seek 2, IO::SEEK_CUR
      end
    end
  end
end