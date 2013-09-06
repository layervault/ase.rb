class ASE
  module Writer
    def to_file(file)
      @file = file
      write!
    end

    def write!
      raise "Must specify an output file" if @file.nil?
      @file = File.new(@file, 'wb')

      palette_count = @palettes.keys.length
      color_count = @palettes.values.map{ |p| p.size }.inject { |sum, i| sum + i }

      # Signature
      @file.write "ASEF"

      # Version
      @file.write_ushort 1, 0

      # Number of blocks
      @file.write_ulong(color_count + (palette_count * 2))

      @palettes.each do |palette_name, palette|
        write_palette(palette_name, palette)
      end

      @file.write_ulong 0 # Group end block
      @file.close
    end

    private

    def write_palette(name, palette)
      # Block start
      @file.write_ushort 0xC001

      # Block length (title is UTF-16 encoded)
      @file.write_ulong 4 + (name.length * 2)

      # Palette name
      @file.write_string name.to_s

      palette.colors.each do |name, color|
        write_color(name, color)
      end

      @file.write_ushort 0xC002 # Group end
    end

    def write_color(name, color)
      # Color start
      @file.write_ushort 1

      # Block length
      @file.write_ulong 22 + (name.length * 2)

      # Color name
      @file.write_string name

      # Color values
      color.write!(@file)
      
      # End of color
      @file.write_null_byte
    end
  end
end