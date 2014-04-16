require 'feature_spec_helper'

feature 'Playlist playback' do

  scenario 'start playback of playlist' do
    playlist = Dabster::Playlist.create
    playlist.add_item({})
  end

end
