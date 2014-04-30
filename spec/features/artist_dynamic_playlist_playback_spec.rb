require 'feature_spec_helper'

feature 'Artist dynamic playlist playback' do

  let!(:artist) { Dabster::Artist.create whatcd_name: 'artist0' }

  scenario 'start playback of dynamic playlist from artist' do
    visit dabster.artist_path(artist)

    click_button 'Start dynamic playlist'
  end

end
