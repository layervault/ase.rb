require 'spec_helper'
require 'tempfile'

describe 'Files' do
  describe 'Reading' do
    it 'throws an error if file is not set' do
      doc = ASE.new

      expect {
        doc.read!
      }.to raise_error
    end

    it 'can read via factory or instantiation' do
      doc1 = ASE.from_file('spec/files/control.ase')
      expect(doc1.palettes.length).to be 1
      
      doc2 = ASE.new('spec/files/control.ase')
      doc2.read!
      expect(doc2.palettes.length).to be 1
    end

    it 'properly reads the palette name' do
      doc = ASE.from_file('spec/files/control.ase')
      expect(doc.palettes).to have_key('Simple')
      expect(doc['Simple']).to eq(doc.palettes['Simple'])
    end

    it 'reads the correct number of colors' do
      doc = ASE.from_file('spec/files/control.ase')
      expect(doc['Simple'].size).to be 2
    end

    it 'correctly reads the color names' do
      doc = ASE.from_file('spec/files/control.ase')
      expect(doc['Simple'].colors).to have_key('White')
      expect(doc['Simple'].colors).to have_key('Black')
    end

    it 'correctly reads the color values' do
      doc = ASE.from_file('spec/files/control.ase')
      expect(doc['Simple']['White'].to_a).to eq([255, 255, 255])
      expect(doc['Simple']['Black'].to_a).to eq([0, 0, 0])
    end
  end

  describe 'Writing' do
    before(:each) do
      doc = ASE.new

      palette = ASE::Palette.new('Test')
      palette.add 'Red', ASE::Color::RGB.new(255, 0, 0)
      palette.add 'Blue', ASE::Color::CMYK.new(0.91, 0.68, 0.2, 0)
      palette.add 'Blah', ASE::Color::Gray.new(0.5)

      doc << palette

      @output = Tempfile.new('output.ase')
      doc.to_file @output.path
    end

    after(:each) do
      @output.unlink
    end

    it 'writes data to the output file' do
      expect(@output.size).to be > 0
    end

    it 'properly writes the palette name' do
      d = ASE.from_file(@output.path)
      expect(d.palettes).to have_key('Test')
    end

    it 'writes the correct number of colors' do
      d = ASE.from_file(@output.path)
      expect(d['Test'].size).to be 3
    end

    it 'writes the correct color names' do
      d = ASE.from_file(@output.path)
      expect(d['Test'].colors).to have_key('Red')
      expect(d['Test'].colors).to have_key('Blue')
    end

    it 'writes the correct color values' do
      d = ASE.from_file(@output.path)
      expect(d['Test']['Red'].to_a).to eq([255, 0, 0])
      expect(d['Test']['Blue'].to_a).to eq([0.91, 0.68, 0.2, 0])
      expect(d['Test']['Blah'].to_a).to eq([0.5])
    end

    it 'writes the correct color types' do
      d = ASE.from_file(@output.path)
      expect(d['Test']['Red']).to be_an_instance_of(ASE::Color::RGB)
      expect(d['Test']['Blue']).to be_an_instance_of(ASE::Color::CMYK)
      expect(d['Test']['Blah']).to be_an_instance_of(ASE::Color::Gray)
    end
  end
end