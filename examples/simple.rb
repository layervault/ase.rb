require 'pp'
require './lib/ase'

doc = ASE.new
palette = ASE::Palette.new("Simple")
palette.add 'White', ASE::Color.from_hex('#ffffff')
palette.add 'Black', ASE::Color.from_hex('#000000')

doc << palette

pp doc

doc.to_file './output.ase'