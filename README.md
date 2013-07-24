# ASE.rb

Reading and writing Adobe Swatch Exchange files in Ruby.

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
palette.add 'Black', ASE::Color.new(0, 0, 0)
palette.add 'Red', ASE::Color.from_hex('#ff0000')

doc << palette
doc.to_file('path/to/file.ase')
```

**Reading**

``` ruby
doc = ASE.from_file('path/to/file.ase')

puts doc['My Colors']['Red'].to_rgb
#=> [255, 0, 0]

puts doc['My Colors'].size
#=> 2
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
