dir_root = File.dirname(File.absolute_path(__FILE__))

require dir_root + "/ase/version"
require dir_root + "/ase/color"
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
    @palettes = []
  end

  def add_palette(palette)
    raise "Can only pass an ASE::Palette" unless palette.is_a?(ASE::Palette)
    @palettes << palette
  end
  alias :<< :add_palette
end
