# ASE.rb

A general purpose library for reading and writing Adobe Swatch Exchange files in Ruby. ASE files can be used across the entire Adobe Creative Suite (Photoshop, Illustrator, etc).

## Installation

Add this line to your application's Gemfile:

    gem 'ase'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ase

## Usage

**Writing**

``` ruby
doc = ASE.new

palette = ASE::Palette.new('My Colors')
palette.add 'Black', ASE::Color::RGB.new(0, 0, 0)
palette.add 'Red', ASE::Color::RGB.from_hex('#ff0000')
palette.add 'Blue', ASE::Color::CMYK.new(0.92, 0.68, 0.2, 0)
palette.add 'Light Gray', ASE::Color::Gray.new(0.75)

doc << palette
doc.to_file('path/to/file.ase')
```

**Reading**

``` ruby
doc = ASE.from_file('path/to/file.ase')

puts doc['My Colors']['Red'].to_a
#=> [255, 0, 0]

puts doc['My Colors'].size
#=> 2
```

## Notes

* If the ASE file does not define a palette, and instead simply lists colors, ASE.rb will use `:default` as the palette name.
* ASE.rb does not support LAB colors yet.
* Because reading & writing CMYK/LAB colors is dependent on your color profile, the output might be different than what is shown in an Adobe application. Color profile support might be added in the future.
* Gray and Grey are interchangeable in ASE.rb

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
