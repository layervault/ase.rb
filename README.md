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

**Reading**

``` ruby
doc = ASE.from_file('path/to/file.ase')

# doc['Palette Name']['Color Name']
puts doc['My Colors']['Red'].to_rgb
#=> [255, 0, 0]
```

**Writing**

``` ruby
doc = ASE.new

palette = ASE::Palette.new('My Colors')
palette.add 'Black', ASE::Color.new(0, 0, 0)
palette.add 'White', ASE::Color.from_hex('#ffffff')

doc << palette
doc.to_file('path/to/file.ase')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
