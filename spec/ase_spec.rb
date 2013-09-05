require 'spec_helper'

describe ASE do
  before(:each) do
    @doc = ASE.new
  end

  it "is initialized with defaults" do
    expect(@doc.palettes).to eq({})
    expect(@doc.palettes.length).to be 0
  end

  it "can add palettes" do
    @doc.add_palette ASE::Palette.new('Test')
    @doc << ASE::Palette.new('Also Test')
  end

  describe ASE::Palette do
    it "must have a name" do
      expect {
        ASE::Palette.new
      }.to raise_error
    end

    it "is initialized with proper defaults" do
      palette = ASE::Palette.new('Test')
      
      expect(palette.name).to eq('Test')
      expect(palette.colors).to eq({})
    end

    it "can add and remove colors" do
      palette = ASE::Palette.new('Test')
      color = ASE::Color::RGB.new(255, 255, 255)
      
      palette.add 'White', color
      expect(palette.colors).to eq({
        'White' => color
      })

      palette.remove 'White'
      expect(palette.colors).to eq({})
    end

    it '#length returns the number of colors' do
      palette = ASE::Palette.new('Test')
      palette.add 'White', ASE::Color::RGB.new(255, 255, 255)
      palette.add 'Black', ASE::Color::RGB.new(0, 0, 0)

      expect(palette.length).to be 2
      expect(palette.size).to be 2
    end

    it '#[] lets you access a specific color' do
      palette = ASE::Palette.new('Test')
      color = ASE::Color::RGB.new(255, 255, 255)

      palette.add 'White', color
      expect(palette['White']).to be color
    end
  end

  describe ASE::Color::RGB do
    it 'can be created with an RGB array' do
      color1 = ASE::Color::RGB.from_rgba [0, 0, 0]
      color2 = ASE::Color::RGB.from_rgb [0, 0, 0]

      expect(color1.to_rgba).to eq([0, 0, 0, 255])
      expect(color2.to_rgba).to eq([0, 0, 0, 255])
    end

    it 'can be created from a hex value' do
      color1 = ASE::Color::RGB.from_hex('#000000')
      color2 = ASE::Color::RGB.from_hex('000000')
      color3 = ASE::Color::RGB.from_hex('#00000000')

      rgba = [0, 0, 0, 255]
      expect(color1.to_rgba).to eq(rgba)
      expect(color2.to_rgba).to eq(rgba)
      expect(color3.to_rgba).to eq([0, 0, 0, 255])
    end
  end
end