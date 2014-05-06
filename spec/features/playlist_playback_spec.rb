require 'feature_spec_helper'

feature 'Playlist playback' do
  include TestSupport::XmmsClientHelper
  include TestSupport::PlaylistHelper
  include TestSupport::Factory

  let!(:playlist) { create_static_playlist }

  before do
    Time.stub(:now).and_return(Time.new(2000, 1, 1))
  end

  scenario 'start playback of playlist' do
    expect(client).to receive(:stop_playback).and_call_original
    expect(client).to receive(:clear_playlist).and_call_original
    expect(client).to receive(:add_entry).with(item0.path).and_call_original
    expect(client).to receive(:add_entry).with(item1.path).and_call_original
    expect(client).to receive(:add_entry).with(item2.path).and_call_original
    expect(client).to receive(:start_playback).and_call_original

    play_playlist playlist
    
    expect(page).to list_items [item0, item1, item2]
    expect(item0.playbacks[0].playback_started_at).to eq(Time.new(2000, 1, 1))
  end

end
