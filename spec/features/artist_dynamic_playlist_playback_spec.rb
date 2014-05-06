require 'feature_spec_helper'

feature 'Artist dynamic playlist playback' do
  include TestSupport::XmmsClientHelper

  let!(:artist0) { Dabster::Artist.create whatcd_name: 'artist0' }
  let!(:artist1) { Dabster::Artist.create whatcd_name: 'artist1' }
  let!(:artist2) { Dabster::Artist.create whatcd_name: 'artist2' }
  let!(:artist3) { Dabster::Artist.create whatcd_name: 'artist2' }
  let!(:item0) { Dabster::Library::Item.create album: 'album', title: 'title0', artist: 'artist0', path: 'path0' }
  let!(:item1) { Dabster::Library::Item.create album: 'album', title: 'title1', artist: 'artist1', path: 'path1' }
  let!(:item2) { Dabster::Library::Item.create album: 'album', title: 'title2', artist: 'artist2', path: 'path2' }
  let!(:item3) { Dabster::Library::Item.create album: 'album', title: 'title3', artist: 'artist3', path: 'path3' }

  before do
    artist0.add_similar_artist(artist1, whatcd_score: 300)
    artist0.add_similar_artist(artist2, whatcd_score: 200)
    artist0.add_similar_artist(artist3, whatcd_score: 100)
    item0.add_artist(artist0, type: :artist, confidence: 1.0)
    item1.add_artist(artist1, type: :artist, confidence: 1.0)
    item2.add_artist(artist2, type: :artist, confidence: 1.0)
    item3.add_artist(artist3, type: :artist, confidence: 1.0)

    expect(client).to receive(:stop_playback).and_call_original
    expect(client).to receive(:clear_playlist).and_call_original
    expect(client).to receive(:add_entry).with(item0.path).and_call_original
    expect(client).to receive(:add_entry).with(item1.path).and_call_original
    expect(client).to receive(:start_playback).and_call_original
  end
    
  scenario 'start playback of dynamic playlist from artist' do
    visit dabster.artist_path(artist0)

    click_button 'Start dynamic playlist'
   
    expect(page).to show_now_playing item0 
    expect(page).to list_items [item0]
  end

  scenario 'next song is queued when when queue advances' do
    visit dabster.artist_path(artist0)
    
    click_button 'Start dynamic playlist'

    expect(client).to receive(:add_entry).with(item2.path).and_call_original
    client.play_next_entry
    
    expect(client).to receive(:add_entry).with(item3.path).and_call_original
    client.play_next_entry
  end
end
