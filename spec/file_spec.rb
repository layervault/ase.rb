require 'spec_helper'

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
      expect(doc['Simple']['White'].to_rgb).to eq([255, 255, 255])
      expect(doc['Simple']['Black'].to_rgb).to eq([0, 0, 0])
    end
  end
end