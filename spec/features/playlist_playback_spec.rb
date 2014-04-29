require 'feature_spec_helper'

feature 'Playlist playback' do
  let!(:playlist) { Dabster::Playlist.create }
  let!(:item0) { Dabster::Library::Item.create title: 'title0', artist: 'artist0', path: 'path0' }
  let!(:item1) { Dabster::Library::Item.create title: 'title1', artist: 'artist1', path: 'path1' }
  let!(:item2) { Dabster::Library::Item.create title: 'title2', artist: 'artist2', path: 'path2' }

  before do
    playlist.add_item(library_item: item0, position: 0)
    playlist.add_item(library_item: item1, position: 1)
    playlist.add_item(library_item: item2, position: 2)
    playlist.update(current_position: 0)
  end

  scenario 'start playback of playlist' do
    expect($client).to receive(:stop_playback)
    expect($client).to receive(:clear_playlist)

    expect($client).to receive(:add_entry).with(item0.path)
    expect($client).to receive(:add_entry).with(item1.path)
    expect($client).to receive(:add_entry).with(item2.path)

    expect($client).to receive(:set_next_position).with(playlist.current_position)
    expect($client).to receive(:start_playback)

    visit dabster.playlist_path(playlist)

    click_button 'Play'

    expect(page).to have_content /now playing: #{item0.title} - #{item0.artist}/i
    expect(page).to have_playlist playlist
  end

end
