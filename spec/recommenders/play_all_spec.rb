require 'unit_spec_helper'
require 'recommenders/play_all.rb'

describe Dabster::Recommenders::PlayAll do

  subject(:play_all) { described_class.new }

  describe 'when selecting an item given an artist' do
    let(:artist) { double 'artist' }

    context 'when all items associated with artist have been played before' do
      before do
        allow(artist).to receive(:random_unplayed_item).and_return(nil)
        allow(artist).to receive(:least_recently_played_item).and_return('played item')
      end
      it 'selects the item associated with the artist played least recently' do
        expect(play_all.select_item(artist)).to eq('played item')
      end
    end

    context 'when artist has no associated items' do
      before do
        allow(artist).to receive(:random_unplayed_item).and_return(nil)
        allow(artist).to receive(:least_recently_played_item).and_return(nil)
      end
      it 'returns nil' do
        expect(play_all.select_item(artist)).to be_nil
      end
    end

    context 'when all items associated with artist have not been played before' do
      before { allow(artist).to receive(:random_unplayed_item).and_return('unplayed item') }
      it 'randomly selects an unplayed item' do
        expect(play_all.select_item(artist)).to eq('unplayed item')
      end
    end

  end

  describe 'when selecting artist given an item' do
    let(:item) { double 'item' }
    let(:artist0) { double 'artist 0', similarity_score: 0.2, last_played_score: 0.8 }
    let(:artist1) { double 'artist 1', similarity_score: 0.7, last_played_score: 0.1 }
    let(:artist2) { double 'artist 2', similarity_score: 0.5, last_played_score: nil }
    let(:artist3) { double 'artist 3', similarity_score: 0.1, last_played_score: nil }
    
    context 'when some artists similar to artists associated with item have not been played before' do
      before { allow(item).to receive(:weighted_similar_artists).and_return([artist1, artist2, artist3]) }
      it 'selects artist with highest similarity score out of artists that have not been played before' do
        expect(play_all.select_artist(item)).to eq(artist2)
      end
    end
    context 'when all artists similar to artists associated with item have been played before' do
      before { allow(item).to receive(:weighted_similar_artists).and_return([artist1, artist0]) }
      it 'selects artist with highest average last played score and similarity' do
        expect(play_all.select_artist(item)).to eq(artist0)
      end
    end
    context 'when item has no similar artists' do
      before { allow(item).to receive(:weighted_similar_artists).and_return([]) }
      it 'returns nil' do
        expect(play_all.select_artist(item)).to be_nil
      end
    end
  end

end
