require 'feature_spec_helper'

feature 'Playback status' do
  scenario 'when no entries have been queued' do
    $playback_proxy.reset

    visit playback_path

    expect(page).to have_content /current playlist not present/i
  end
end
