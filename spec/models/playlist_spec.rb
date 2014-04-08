require 'db_spec_helper'
require 'playlist'

describe Dabster::Playlist do
  subject(:playlist) { described_class.new }

  describe 'when getting last played item' do
    let!(:saved_playlist) { playlist.save }
    let!(:item0) { playlist.add_item({}) }
    let!(:item1) { playlist.add_item({}) }
    let!(:item2) { playlist.add_item({}) }

    it 'returns item added to playlist most recently' do
      expect(playlist.last_played_item).to eq(item2)
    end

  end
end
