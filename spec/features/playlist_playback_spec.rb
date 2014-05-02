require 'feature_spec_helper'

feature 'Playlist playback' do
  include TestSupport::XmmsClientHelper

  def play_playlist
    click_button 'Play'
    change_queue_position 0
    expect(page).to show_now_playing item0
  end

  let!(:playlist) { Dabster::Playlist.create }
  let!(:item0) { Dabster::Library::Item.create title: 'title0', artist: 'artist0', path: 'path0' }
  let!(:item1) { Dabster::Library::Item.create title: 'title1', artist: 'artist1', path: 'path1' }
  let!(:item2) { Dabster::Library::Item.create title: 'title2', artist: 'artist2', path: 'path2' }
  let!(:item3) { Dabster::Library::Item.create title: 'title3', artist: 'artist3', path: 'path3' }

  before do
    Time.stub(:now).and_return(Time.new(2000, 1, 1))

    playlist.add_item(library_item: item0, position: 0)
    playlist.add_item(library_item: item1, position: 1)
    playlist.add_item(library_item: item2, position: 2)
    playlist.add_item(library_item: item3, position: 3)
    playlist.update(current_position: 0)
    
    expect(client).to receive(:stop_playback)
    expect(client).to receive(:clear_playlist).and_call_original
    
    expect(client).to receive(:add_entry).with(item0.path).and_call_original
    expect(client).to receive(:add_entry).with(item1.path).and_call_original
    
    expect(client).to receive(:start_playback)

    visit dabster.playlist_path(playlist)
  end

  scenario 'start playback of playlist' do
    play_playlist
    
    expect(page).to list_items [item0, item1, item2]

    expect(item0.playbacks[0].playback_started_at).to eq(Time.new(2000, 1, 1))
  end

  scenario 'add next song in playlist when queue advances' do
    play_playlist

    expect(client).to receive(:add_entry).with(item2.path).and_call_original

    change_queue_position 1
  end
  
  scenario 'add next song in playlist when queue advances twice' do
    play_playlist
    
    expect(client).to receive(:add_entry).with(item2.path).and_call_original
    change_queue_position 1
    
    expect(client).to receive(:add_entry).with(item3.path).and_call_original
    change_queue_position 2
  end

end
