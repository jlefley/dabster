require 'feature_spec_helper'

feature 'Playlist playback' do
  let!(:playlist) { Dabster::Playlist.create }
  let!(:item0) { Dabster::Library::Item.create title: 'title0', artist: 'artist0' }
  let!(:item1) { Dabster::Library::Item.create title: 'title1', artist: 'artist1' }
  let!(:item2) { Dabster::Library::Item.create title: 'title2', artist: 'artist2' }

  before do
    playlist.add_item(library_item: item0, position: 0)
    playlist.add_item(library_item: item1, position: 1)
    playlist.add_item(library_item: item2, position: 2)
    playlist.update(current_position: 0)
  end

  scenario 'start playback of playlist' do
    visit dabster.playlist_path(playlist)

    click_button 'Play'

    expect(page).to have_content /now playing: #{item0.title} - #{item0.artist}/i
    expect(page).to have_playlist playlist
  end

end
