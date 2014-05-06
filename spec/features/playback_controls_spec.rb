require 'feature_spec_helper'

feature 'Playback controls', js: true do
  include TestSupport::XmmsClientHelper
  include TestSupport::PlaylistHelper
  include TestSupport::Factory

  let!(:playlist) { create_static_playlist }
  
  scenario 'pause' do
    play_playlist playlist
    
    expect(client).to receive(:pause_playback).and_call_original

    click_button '❚❚'

    expect(page).to have_content /paused/i
  end

  scenario 'play after pausing'

  scenario 'skip forward' do
    play_playlist playlist
  end

  scenario 'skip backward when current item is not first in playlist'

  scenario 'skip backward when current item is first in playlist'

end
