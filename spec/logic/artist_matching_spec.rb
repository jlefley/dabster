require 'unit_spec_helper'
require 'artist_matching'

describe ArtistMatching do

  describe 'when matching items' do
    let(:artist0) { double 'artist 0', what_name: 'Mike ShiveR' }
    let(:artist1) { double 'artist 1', what_name: 'Aruna  ' }
    let(:artist2) { double 'artist 2', what_name: 'Super8 & Tab' }
    let(:artist3) { double 'artist 3', what_name: 'Other' }
    let(:item0) { double 'item 0', artists: [], add_artist: nil, artist: 'Mike Shiver & Aruna' }
    let(:item1) { double 'item 1', artists: [], add_artist: nil, artist: '  Super8 & Tab' }
    
    subject do
      cls = Struct.new(:library_items, :artists) { include ArtistMatching }
      cls.new([item0, item1], [artist0, artist1, artist2, artist3])
    end

    describe 'when artist name is contained in item artist' do
      it 'adds the artist to the item' do
        expect(item0).to receive(:add_artist).with(artist0)
        expect(item0).to receive(:add_artist).with(artist1)
        expect(item1).to receive(:add_artist).with(artist2)

        subject.match_artists
      end

      describe 'when item already has the artist' do
        it 'should not add the artist to the item' do
          allow(item0).to receive(:artists).and_return([artist0])

          expect(item0).not_to receive(:add_artist).with(artist0)
          
          subject.match_artists
        end
      end
    end

    describe 'when artist name is not contained in item artist' do
      it 'does not add the artist any item' do
        expect(item0).not_to receive(:add_artist).with(artist3)
        expect(item1).not_to receive(:add_artist).with(artist3)

        subject.match_artists
      end
    end
  end

end
