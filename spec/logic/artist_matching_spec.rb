require 'unit_spec_helper'
require 'artist_matching'

describe ArtistMatching do
  
  let(:artist0) { double 'artist 0', what_name: 'Mike ShiveR' }
  let(:artist1) { double 'artist 1', what_name: 'Aruna  ' }
  let(:artist2) { double 'artist 2', what_name: 'Super8 & Tab' }
  let(:artist3) { double 'artist 3', what_name: 'Other' }
  
  let(:item0) { double 'item 0', artists: { }, add_artist: nil, artist: 'Mike Shiver & Aruna' }
  let(:item1) { double 'item 1', artists: { }, add_artist: nil, artist: '  Super8 & Tab' }
  
  subject(:group) do
    group_cls = Struct.new(:library_items, :artists, :what_artist, :what_artist_type) { include ArtistMatching }
    group_cls.new([item0, item1], { artist: [artist0, artist1], dj: [artist2, artist0], with: [artist3] }, artist2, :dj)
  end

  describe 'when unmatching artists with items' do
    it 'removes all artists from each associated item that do not have the artist name contained in the item artist' do
      allow(item0).to receive(:artists).and_return(dj: [artist2])
      allow(item1).to receive(:artists).and_return(dj: [artist2])

      expect(item0).to receive(:remove_artist).with(artist2, :dj)

      group.unmatch_implicit_artist
    end
  end

  describe 'when matching artist with items according to implicit group association' do
    it 'adds what_artist every item associated with group that is not yet associated with what_artist' do
      allow(item1).to receive(:artists).and_return(dj: [artist2])

      expect(item0).to receive(:add_artist).with(artist2, :dj)
      expect(item1).not_to receive(:add_artist)

      group.match_implicit_artist
    end
  end

  describe 'when matching items with artists' do

    describe 'when artist name is contained in item artist' do
      it 'adds the artist to the item' do
        expect(item0).to receive(:add_artist).with(artist0, :artist)
        expect(item0).to receive(:add_artist).with(artist1, :artist)
        expect(item1).to receive(:add_artist).with(artist2, :dj)
        expect(item0).to receive(:add_artist).with(artist0, :dj)

        group.match_artists
      end

      describe 'when item already has the artist' do
        it 'should not add the artist to the item' do
          allow(item0).to receive(:artists).and_return(artist: [artist0], dj: [], with: [])

          expect(item0).not_to receive(:add_artist).with(artist0, :artist)
          
          group.match_artists
        end
      end
    end

    describe 'when artist name is not contained in item artist' do
      it 'does not add the artist any item' do
        expect(item0).not_to receive(:add_artist).with(artist3, anything())
        expect(item1).not_to receive(:add_artist).with(artist3, anything())

        group.match_artists
      end
    end
  end

end
