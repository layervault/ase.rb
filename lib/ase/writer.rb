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

        title = palette.name

        # Block length (title is UTF-16 encoded)
        @file.write_ulong 4 + (title.length * 2)

        # Title length
        @file.write_ushort(title.length + 1)

        # The title
        @file.write title.encode('UTF-16BE')
        @file.write 0x00

        palette.colors.each do |name, color|
          # Color start
          @file.write_ushort 1

          # Block length
          @file.write_ulong 22 + (name.length * 2)

          # Color name length
          @file.write_ushort(name.length + 1)

          # Color name
          @file.write name.encode('UTF-16BE')
          @file.write 0x00

          # Color mode
          @file.write 'RGB '

          # Colors
          rgb = color.to_rgb.map { |c| c / 255 }
          rgb.each { |c| @file.write_float(c) }
          
          # End of colors
          @file.write 0x00
        end

        @file.write_ushort 0xC002 # Group end
        @file.write_ulong 0 # Group end block
      end
    end
  end
end