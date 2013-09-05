require 'spec_helper'

describe ASE::Color do
  it "has a working factory method" do
    expect(ASE::Color).to respond_to(:factory)
  end

  describe ASE::Color::RGB do
    it "works with the color factory" do
      expect(ASE::Color.factory('RGB')).to be_an_instance_of(ASE::Color::RGB)
      expect(ASE::Color.factory('RGB ')).to be_an_instance_of(ASE::Color::RGB)
    end

    it 'can be created with an RGB array' do
      color1 = ASE::Color::RGB.from_rgba [0, 0, 0]
      color2 = ASE::Color::RGB.from_rgb [0, 0, 0]

      expect(color1.to_a).to eq([0, 0, 0])
      expect(color2.to_a).to eq([0, 0, 0])
    end

    it 'can be created from a hex value' do
      color1 = ASE::Color::RGB.from_hex('#000000')
      color2 = ASE::Color::RGB.from_hex('000000')
      color3 = ASE::Color::RGB.from_hex('#00000000')

      rgb = [0, 0, 0]
      expect(color1.to_a).to eq(rgb)
      expect(color2.to_a).to eq(rgb)
      expect(color3.to_a).to eq([0, 0, 0])
    end

    it "returns itself when calling to_rgb" do
      color = ASE::Color::RGB.new(10, 10, 10)
      expect(color.to_rgb).to be color
    end

    it "can be expressed as an array" do
      color = ASE::Color::RGB.new(10, 10, 10)
      expect(color.to_a).to eq([10, 10, 10])
    end
  end

  describe ASE::Color::Gray do
    it "works with the color factory" do
      expect(ASE::Color.factory('Gray')).to be_an_instance_of(ASE::Color::Gray)
    end

    it "has a readable value" do
      color = ASE::Color::Gray.new(0.75)
      expect(color.value).to eq(0.75)
    end

    it "can be expressed as an array" do
      color = ASE::Color::Gray.new(0.75)
      expect(color.to_a).to eq([0.75])
    end

    it "can be converted to RGB" do
      color = ASE::Color::Gray.new(0.75)
      rgb = color.to_rgb

      rgb_value = (255 * 0.75).to_i
      expect(rgb).to be_an_instance_of(ASE::Color::RGB)
      expect(rgb.to_a).to eq([rgb_value] * 3)
    end
  end

  describe ASE::Color::CMYK do
    it "works with the color factory" do
      expect(ASE::Color.factory('CMYK')).to be_an_instance_of(ASE::Color::CMYK)
    end

    it "has readable values" do
      color = ASE::Color::CMYK.new(0.1, 0.2, 0.3, 0.4)
      expect(color.c).to eq(0.1)
      expect(color.m).to eq(0.2)
      expect(color.y).to eq(0.3)
      expect(color.k).to eq(0.4)
    end

    it "can be expressed as an array" do
      color = ASE::Color::CMYK.new(0.1, 0.2, 0.3, 0.4)
      expect(color.to_a).to eq([0.1, 0.2, 0.3, 0.4])
    end

    it "can be converted to RGB" do
      color = ASE::Color::CMYK.new(0.1, 0.2, 0.3, 0.4)
      rgb = color.to_rgb

      expect(rgb).to be_an_instance_of(ASE::Color::RGB)
      expect(rgb.to_a).to eq([137, 122, 107])
    end
  end
end