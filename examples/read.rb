require 'pp'
require './lib/ase'

puts "Must specify a file" and exit if ARGV.length == 0

doc = ASE.from_file(ARGV[0])
pp doc