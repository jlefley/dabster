require 'feature_spec_helper'

feature 'Artist dynamic playlist playback' do

  let!(:artist0) { Dabster::Artist.create whatcd_name: 'artist0' }
  let!(:artist1) { Dabster::Artist.create whatcd_name: 'artist1' }
  let!(:item0) { Dabster::Library::Item.create album: 'album', title: 'title0', artist: 'artist0', path: 'path0' }
  let!(:item1) { Dabster::Library::Item.create album: 'album', title: 'title1', artist: 'artist1', path: 'path1' }

  before do
    artist0.add_similar_artist(artist1, whatcd_score: 100)
    item0.add_artist(artist0, type: :artist, confidence: 1.0)
    item1.add_artist(artist1, type: :artist, confidence: 1.0)
  end

  scenario 'start playback of dynamic playlist from artist' do
    expect($client).to receive(:stop_playback)
    expect($client).to receive(:clear_playlist)
    
    expect($client).to receive(:add_entry).with(item0.path)
    expect($client).to receive(:add_entry).with(item1.path)
    
    expect($client).to receive(:start_playback)
    
    visit dabster.artist_path(artist0)

    click_button 'Start dynamic playlist'
   
    expect(page).to show_now_playing item0 
    expect(page).to list_items [item0, item1]
  end

end
