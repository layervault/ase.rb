class ASE
  module Writer
    def to_file(file)
      @file = file
      write!
    end

    def write!
      raise "Must specify an output file" if @file.nil?
      @file = File.new(@file, 'wb')

      palette_count = @palettes.length
      color_count = @palettes.inject(0) { |sum, p| p.size }

      # Signature
      @file.write "ASEF"

      # Version
      @file.write_ushort 1, 0

      # Number of blocks
      @file.write_ulong(color_count + (palette_count * 2))

      @palettes.each do |palette_name, palette|
        # Block start
        @file.write_ushort 0xC001

        # Block length (title is UTF-16 encoded)
        @file.write_ulong 4 + (palette_name.length * 2)

        # Palette name
        @file.write_string palette_name

        palette.colors.each do |name, color|
          # Color start
          @file.write_ushort 1

          # Block length
          @file.write_ulong 22 + (name.length * 2)

          # Color name
          @file.write_string name

          # Color mode
          @file.write 'RGB '

          # Colors
          rgb = color.to_rgb.map { |c| c.to_f / 255 }
          rgb.each { |c| @file.write [c].pack('F').reverse }
          
          # End of colors
          @file.write_null_byte
        end

        @file.write_ushort 0xC002 # Group end
        @file.write_ulong 0 # Group end block
      end

      @file.close
    end
  end
end