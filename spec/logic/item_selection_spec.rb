require 'unit_spec_helper'
require 'logic/item_selection'

describe Dabster::Logic::ItemSelection do
  subject(:artist) do
    Struct.new(:least_recently_played_item, :random_unplayed_item) { include Dabster::Logic::ItemSelection }.new
  end

  describe 'when least played item is selected' do

    context 'when all items associated with artist have been played before' do
      before do
        artist.least_recently_played_item = 'played item'
      end
      it 'selects the item associated with the artist played least recently' do
        expect(artist.least_played_item).to eq('played item')
      end
    end

    context 'when artist has no associated items' do
      it 'returns nil' do
        expect(artist.least_played_item).to be_nil
      end
    end

    context 'when all items associated with artist have not been played before' do
      before { artist.random_unplayed_item = 'unplayed item' }
      it 'randomly selects an unplayed item' do
        expect(artist.least_played_item).to eq('unplayed item')
      end
    end

  end
end

