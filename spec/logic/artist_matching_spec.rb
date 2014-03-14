require 'unit_spec_helper'
require 'artist_matching'

describe ArtistMatching do

  describe 'when matching items' do
    let(:artist0) { double 'artist 0', what_name: 'Mike ShiveR' }
    let(:artist1) { double 'artist 1', what_name: 'Aruna  ' }
    let(:artist2) { double 'artist 2', what_name: 'Super8 & Tab' }
    let(:artist3) { double 'artist 3', what_name: 'Other' }
    let(:item0) { double 'item 0', artists: { artist: [], dj: [], with: [] }, add_artist: nil, artist: 'Mike Shiver & Aruna' }
    let(:item1) { double 'item 1', artists: { artist: [], dj: [], with: [] }, add_artist: nil, artist: '  Super8 & Tab' }
    
    subject(:group) do
      group_cls = Struct.new(:library_items, :artists) { include ArtistMatching }
      group_cls.new([item0, item1], { artist: [artist0, artist1], dj: [artist2, artist0], with: [artist3] })
    end

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
