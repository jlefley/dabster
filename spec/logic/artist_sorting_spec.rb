require 'unit_spec_helper'
require 'logic/artist_sorting'

describe Dabster::Logic::ArtistSorting do

  subject(:artist) do
    Struct.new(:weighted_similar_artists) { include Dabster::Logic::ArtistSorting }.new
  end

  let(:artist0) { double 'artist 0', similarity_score: 0.2, last_played_score: 0.8 }
  let(:artist1) { double 'artist 1', similarity_score: 0.7, last_played_score: 0.1 }
  let(:artist2) { double 'artist 2', similarity_score: 0.5, last_played_score: nil }
  let(:artist3) { double 'artist 3', similarity_score: 0.1, last_played_score: nil }

  describe 'when sorting similar artists' do

    context 'when some similar artists have not been played before' do
      before { artist.weighted_similar_artists = [artist1, artist2, artist3] }
      it 'returns artists sorted by highest similarity score out of artists that have not been played before' do
        expect(artist.sorted_similar_artists).to eq([artist2, artist3])
      end

    end

    context 'when all similar artists have been played before' do
      before { artist.weighted_similar_artists = [artist1, artist0] }
      it 'returns artists sorted by highest average last played score and similarity' do
        expect(artist.sorted_similar_artists).to eq([artist0, artist1])
      end
    end

    context 'when artist has no similar artists' do
      before { artist.weighted_similar_artists = [] }
      it 'returns empty array' do
        expect(artist.sorted_similar_artists).to be_empty
      end
    end

  end
end
