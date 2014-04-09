require 'unit_spec_helper'
require 'recommenders/play_all.rb'

describe Dabster::Recommenders::PlayAll do

  subject(:play_all) { described_class.new }
  
  let(:artist) { double 'artist' }
  let(:item) { double 'item' }
  let(:artist0) { double 'artist 0', similarity_score: 0.2, last_played_score: 0.8 }
  let(:artist1) { double 'artist 1', similarity_score: 0.7, last_played_score: 0.1 }
  let(:artist2) { double 'artist 2', similarity_score: 0.5, last_played_score: nil }
  let(:artist3) { double 'artist 3', similarity_score: 0.1, last_played_score: nil }

  describe 'when selecting an item given an artist' do

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

  describe 'when selecting artists given an item' do
    
    context 'when some artists similar to artists associated with item have not been played before' do
      before { allow(item).to receive(:weighted_similar_artists).and_return([artist1, artist2, artist3]) }
      it 'returns artists sorted by highest similarity score out of artists that have not been played before' do
        expect(play_all.select_artists_by_item(item)).to eq([artist2, artist3])
      end
    end
    context 'when all artists similar to artists associated with item have been played before' do
      before { allow(item).to receive(:weighted_similar_artists).and_return([artist1, artist0]) }
      it 'returns artists sorted by highest average last played score and similarity' do
        expect(play_all.select_artists_by_item(item)).to eq([artist0, artist1])
      end
    end
    context 'when item has no similar artists' do
      before { allow(item).to receive(:weighted_similar_artists).and_return([]) }
      it 'returns empty array' do
        expect(play_all.select_artists_by_item(item)).to be_empty
      end
    end
  end

  describe 'when selecting artists given an artist' do
    context 'when some artists similar to artists associated with item have not been played before' do
      before { allow(artist).to receive(:weighted_similar_artists).and_return([artist1, artist2, artist3]) }
      it 'returns artists sorted by highest similarity score out of artists that have not been played before' do
        expect(play_all.select_artists_by_artist(artist)).to eq([artist2, artist3])
      end
    end
    context 'when all artists similar to artists associated with item have been played before' do
      before { allow(artist).to receive(:weighted_similar_artists).and_return([artist1, artist0]) }
      it 'returns artists sorted by highest average last played score and similarity' do
        expect(play_all.select_artists_by_artist(artist)).to eq([artist0, artist1])
      end
    end
    context 'when artist has no similar artists' do
      before { allow(artist).to receive(:weighted_similar_artists).and_return([]) }
      it 'returns empty array' do
        expect(play_all.select_artists_by_artist(artist)).to be_empty
      end
    end
  end

end
