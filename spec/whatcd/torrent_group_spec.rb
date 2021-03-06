require 'unit_spec_helper'
require 'whatcd/torrent_group'

describe Dabster::Whatcd::TorrentGroup do

  let(:result_group) { {
    groupId: 410618,
    groupName: 'Jungle Music &amp; More',
    artist: 'Above &amp; Beyond',
    tags: ['tag'],
    groupYear: 2000,
    releaseType: 'Album',
    torrents: [
      { artists: [{ id: 1460, name: 'Logistics'}] },
      { artists: [{ id: 1460, name: 'Logistics'}] }
    ]
  } }

  let(:torrent_group) { {
    id: 44,
    name: 'Jungle Music &amp; More',
    year: 2001,
    musicInfo: { artists: 'artists', composers: 'composers', dj: 'djs', conductor: 'conductors',
      remixedBy: 'remixed_bys', producer: 'producers', with: 'withs' },
    recordLabel: 'Label',
    catalogueNumber: 'cat_no'
  } }

  describe 'when constructed with result group' do
    subject(:group) { described_class.new result_group }
    it 'allows access to groupId as id' do
      expect(group.id).to eq(410618)
    end
    it 'allows access to HTML decoded groupName as name' do
      expect(group.name).to eq('Jungle Music & More')
    end
    it 'allows access to HTML decoded artist' do
      expect(group.artist).to eq('Above & Beyond')
    end
    it 'allows access to tags' do
      expect(group.tags).to eq(['tag'])
    end
    it 'allows access to groupYear as year' do
      expect(group.year).to eq(2000)
    end
    it 'allows access to releaseType as release_type' do
      expect(group.release_type).to eq('Album')
    end
    it 'allows access to uniuque array of objects corresponding to artists in torrents' do
      artists = group.torrent_artists
      expect(artists.first.id).to eq(1460)
      expect(artists.first.name).to eq('Logistics')
      expect(artists.length).to eq(1)
    end
  end

  describe 'when constructed with torrent group' do
    subject(:group) { described_class.new torrent_group }
    it 'allows access to id' do
      expect(group.id).to eq(44)
    end
    it 'allows access to HTML decoded name' do
      expect(group.name).to eq('Jungle Music & More')
    end
    it 'allows access to year' do
      expect(group.year).to eq(2001)
    end
    it 'allows access to musicInfo as artists' do
      expect(group.artists).to eq(artist: 'artists', conductor: 'conductors',
        dj: 'djs', composer: 'composers', with: 'withs', remixed_by: 'remixed_bys', producer: 'producers')
    end
    it 'allows access to recordLabel as record_label' do
      expect(group.record_label).to eq('Label')
    end
    it 'allows access to catalogueNumber as catalog_number' do
      expect(group.catalog_number).to eq('cat_no')
    end
  end

  describe 'when mapping fields' do
    subject(:group) { described_class.new(result_group) }
    it 'returns HTML decoded values with keys mapped according to specified mapping' do
      mapping = { artist: :the_artist, id: :the_id, name: :the_name }
      expect(group.map(mapping)).to eq(the_id: 410618, the_name: 'Jungle Music & More', the_artist: 'Above & Beyond')
    end
    describe 'when mapping specifies a field with nil value' do
      it 'raises KeyError' do
        expect { group.map(other: :field) }.to raise_error(KeyError)
      end
    end
  end

end
