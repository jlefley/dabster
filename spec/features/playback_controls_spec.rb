require 'feature_spec_helper'

feature 'Playback controls', js: true do
  include TestSupport::XmmsClientHelper
  include TestSupport::PlaylistHelper
  include TestSupport::Factory

  let!(:playlist) { create_static_playlist }
 
  before do
    play_playlist playlist
  end

  scenario 'pause' do
    expect(client).to receive(:pause_playback).and_call_original

    click_button '❚❚'

    expect(page).to have_content /paused/i
    expect(page).to have_button('❚❚', disabled: true)
  end

  scenario 'play after pausing' do
    click_button '❚❚'
    expect(page).to have_content /paused/i

    expect(client).to receive(:start_playback).and_call_original

    click_button '▶'
    
    expect(page).to show_now_playing item0
    expect(page).to have_button('▶', disabled: true)
  end

  scenario 'skip forward' do
    expect(client).to receive(:play_next_entry).and_call_original
    
    click_button '▶▶'
    
    expect(page).to show_now_playing item1
  end

  scenario 'skip backward when current item is not first in playlist' do
    click_button '▶▶'
    expect(page).to show_now_playing item1
    
    expect(client).to receive(:play_previous_entry).and_call_original
    
    click_button('◀◀')
    expect(page).to show_now_playing item0
  end

  scenario 'skip backward button is disabled when current item is first in playlist' do
    expect(page).to have_button('◀◀', disabled: true)
  end

end
