class ASE
  module Writer
    def to_file(file)
      @file = file
      write!
    end

    def write!
      @file = File.new(@file, 'wb')

      palette_count = @palettes.length
      color_count = @palettes.inject(0) { |sum, p| p.size }

      # Signature
      @file.write "ASEF"

      # Version
      @file.write_ushort 1, 0

      # Number of blocks
      @file.write_ulong(color_count + (palette_count * 2))

      @palettes.each do |palette|
        # Block start
        @file.write_ushort 0xC001

        title = palette.name.encode('UTF-8') + "\x00"

        # Length of the block title
        buffer = [title.length / 2].pack('S')
        buffer += title

        # Length of this block
        @file.write_ulong buffer.length
        @file.write buffer

        palette.colors.each do |name, color|
          # Color start
          @file.write_ushort 1

          # Color title
          title = name.to_s.encode('UTF-8') + "\x00"

          buffer = [title.length / 2].pack('S')
          buffer += title

          # Colors
          rgb = color.to_rgb.map { |c| c / 255 }

          buffer += "RGB "
          rgb.each { |c| buffer += [c].pack('f').reverse }
          buffer += "\x00"

          # Length of color block
          @file.write_ulong buffer.length
          @file.write buffer
        end

        @file.write_ushort 0xC002 # Group end
        @file.write_ulong 0 # Group end block
      end
    end
  end
end