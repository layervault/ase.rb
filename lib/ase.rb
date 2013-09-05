dir_root = File.dirname(File.absolute_path(__FILE__))

require dir_root + "/ase/version"

require dir_root + "/ase/color_modes/cmyk"
require dir_root + "/ase/color_modes/gray"
require dir_root + "/ase/color_modes/rgb"

require dir_root + "/ase/file"
require dir_root + "/ase/palette"
require dir_root + "/ase/reader"
require dir_root + "/ase/writer"

class ASE
  include Reader
  include Writer

  attr_accessor :palettes

  def initialize(file=nil)
    @file = file
    @palettes = {}
  end

  def add_palette(palette)
    raise "Can only pass an ASE::Palette" unless palette.is_a?(ASE::Palette)
    @palettes[palette.name] = palette
  end
  alias :<< :add_palette

  def [](name)
    @palettes[name]
  end

  def method_missing(method, *args, &block)
    if @palettes.has_key?(method.to_s)
      return @palettes[method.to_s]
    end

    super
  end
end
