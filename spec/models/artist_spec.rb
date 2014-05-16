require 'app_spec_helper'

describe Dabster::Artist do
  subject(:artist) { described_class.new }

  it { should be_valid }

  describe 'when whatcd_id is present' do
    before do
      artist.whatcd_id = 1
      artist.whatcd_name = 'asdf'
      artist.whatcd_updated_at = Time.now
    end
    describe 'when all what fields are present' do
      it { should be_valid }
    end
    describe 'when whatcd_name is missing' do
      before { artist.whatcd_name = nil }
      it { should_not be_valid }
    end
    describe 'when whatcd_updated_at is missing' do
      before { artist.whatcd_updated_at = nil }
      it { should_not be_valid }
    end
  end

  describe 'when determining if artist is associated with tracks belonging to a specified library album' do
    describe 'when artist is associated with tracks belonging to specified library album' do
      it 'returns the number of items the artist is associated with' do
      end
    end
    describe 'when artist is not associated with any tracks belonging to library album' do
      it 'returns false' do
      end
    end
  end

  describe 'when selecting artists having items' do
    let!(:other_artist) { described_class.create }
    let!(:saved_artist) { artist.save }
    let!(:item0) { artist.add_item({}, type: :artist, confidence: 1) }
    
    it 'returns artists matching criteria and having items' do
      expect(described_class.where(artists__id: [other_artist.id, artist.id]).having_items.all).to match_array([artist])
    end
  end

  describe 'when querying for item information' do

    let!(:playlist) { Dabster::Playlist.create }    
    let!(:saved_artist) { artist.save }
    let!(:item0) { artist.add_item({}, type: :artist, confidence: 1) }
    let!(:item1) { artist.add_item({}, type: :artist, confidence: 1) }
    let!(:item2) { artist.add_item({}, type: :artist, confidence: 1) }
    let!(:playback0) { item0.add_playback }
    let!(:playback1) { item0.add_playback }
    let!(:playback2) { item1.add_playback }
    let!(:playback3) { item1.add_playback }

    context 'when getting the last time artist was played' do
      it 'returns the latest playback time of all items associated with artist' do
        expect(artist.last_played_at).to eq(playback3.playback_started_at)
      end
    end

    context 'when getting least recently played item' do
      it 'returns the item last played longest ago' do
        expect(artist.least_recently_played_item).to eq(item0)
      end
    end

    context 'when getting random unplayed item' do
      it 'returns unplayed item' do
        expect(artist.random_unplayed_item).to eq(item2)
      end
    end
  end
end
