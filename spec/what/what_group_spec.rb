require 'unit_spec_helper'
require 'what_group'

describe WhatGroup do

  let(:result) {
    {
      groupId: 410618,
      groupName: 'Jungle Music &amp; More',
      artist: 'Above &amp; Beyond',
      torrents: [
        { artists: [{ id: 1460, name: 'Logistics'}] },
        { artists: [{ id: 1460, name: 'Logistics'}] }
      ]
    }
  }

  subject { WhatGroup.new result }

  describe 'when calling accessor method not corresponding to first level hash key' do
    it 'raises error' do
      expect { subject.other }.to raise_error(KeyError)
    end
  end

  describe 'when accessing first level values through methods' do

    it 'returns value' do
      expect(subject.groupId).to eq(410618)
    end

    describe 'when field is artist' do
      it 'returns the HTML decoded value' do
        expect(subject.artist).to eq('Above & Beyond')
      end
    end
    
    describe 'when field is groupName' do
      it 'returns the HTML decoded value' do
        expect(subject.groupName).to eq('Jungle Music & More')
      end
    end 

  end

  describe 'when accessing artists' do

    it 'returns uniuque array of objects corresponding to artists' do
      artists = subject.artists
      expect(artists.first.id).to eq(1460)
      expect(artists.first.name).to eq('Logistics')
      expect(artists.length).to eq(1)
    end

  end

  describe 'when accessing artists hashes' do
    it 'returns unique array of artist hashes' do
      expect(subject.artists_hashes).to eq([{ id: 1460, name: 'Logistics' }])
    end
  end

  describe 'when mapping fields' do
    let(:mapping) { { artist: :artist_name, groupId: :id, groupName: :name } }
    it 'returns HTML decoded values with keys mapped according to specified mapping' do
      expect(subject.map(mapping)).to eq(id: 410618, name: 'Jungle Music & More', artist_name: 'Above & Beyond')
    end
  end

  describe 'when accessing id' do
    it 'returns value of groupId' do
      expect(subject.id).to eq(410618)
    end
  end

end
