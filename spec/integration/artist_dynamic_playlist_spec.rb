require 'app_spec_helper'

describe 'Dynamic playlist based on single artist having two similar artists with traversal depth of one', type: :feature do
  
  let!(:artist0) { Dabster::Artist.create whatcd_name: 'initital artist' }
  let!(:artist1) { Dabster::Artist.create whatcd_name: 'similar artist 1' }
  let!(:artist2) { Dabster::Artist.create whatcd_name: 'similar artist 2' }
  let!(:item0) { Dabster::Library::Item.create title: 'item0' }
  let!(:item1) { Dabster::Library::Item.create title: 'item1' }
  let!(:item2) { Dabster::Library::Item.create title: 'item2' }
  let!(:item3) { Dabster::Library::Item.create title: 'item3' }
  let!(:item4) { Dabster::Library::Item.create title: 'item4' }
  let!(:item5) { Dabster::Library::Item.create title: 'item5' }
  let!(:playlist) { Dabster::Playlist.create }

  before do
    artist0.add_similar_artist(artist1, whatcd_score: 200)
    artist0.add_similar_artist(artist2, whatcd_score: 100)
    item0.add_artist(artist0, type: :artist, confidence: 1.0)
    item1.add_artist(artist0, type: :artist, confidence: 1.0)
    item2.add_artist(artist1, type: :artist, confidence: 1.0)
    item3.add_artist(artist1, type: :artist, confidence: 1.0)
    item4.add_artist(artist2, type: :artist, confidence: 1.0)
    item5.add_artist(artist2, type: :artist, confidence: 1.0)
    playlist.initialize_with_artist(artist0)
  end

  context 'when first song is selected' do
    it 'returns least recently played item from initial artist' do
      expect([item0, item1]).to include(playlist.current_item.library_item)
    end
  end

  context 'when second song is selected' do
    it 'returns least recently played item from artist most similar to initial artist' do
      item0.add_playback

      expect([item2, item3]).to include(playlist.next_item.library_item)
    end
  end

  context 'when third song is selected' do
    it 'returns least recently played item from artist least similar to initial artist' do
      item0.add_playback
      item2.add_playback
      playlist.increment_current_position

      expect([item4, item5]).to include(playlist.next_item.library_item)
    end
  end

  context 'when fourth song is selected' do
    it 'returns least recently played item from initial artist' do
      item0.add_playback
      item2.add_playback
      item4.add_playback
      playlist.increment_current_position
      playlist.increment_current_position

      expect(playlist.next_item.library_item).to eq(item1)
    end
  end

  context 'when fifth song is selected' do
    it 'returns least recently played item from artist most similar to initial artist' do
      item0.add_playback
      item2.add_playback
      item4.add_playback
      item1.add_playback
      playlist.increment_current_position
      playlist.increment_current_position
      playlist.increment_current_position
      
      expect(playlist.next_item.library_item).to eq(item3)
    end
  end

  context 'when sixth song is selected' do
    it 'returns least recently played item from artist least similar to initial artist' do
      # Add playback to item 4 first to allow enough time to pass so item 5 is selected rather than item 0
      item4.add_playback
      item0.add_playback
      item2.add_playback
      item1.add_playback
      item3.add_playback
      playlist.increment_current_position
      playlist.increment_current_position
      playlist.increment_current_position
      playlist.increment_current_position
      
      expect(playlist.next_item.library_item).to eq(item5)
    end
  end
  
end
