require 'unit_spec_helper'
require 'logic/similar_artists_normalizer'
require 'ostruct'

describe Dabster::Logic::SimilarArtistsNormalizer do
  let(:rel0) { double 'relationship 0', whatcd_score: 100, similar_artist_id: 1 }
  let(:rel1) { double 'relationship 1', whatcd_score: 100, similar_artist_id: 1 }
  let(:rel2) { double 'relationship 2', whatcd_score: 400, similar_artist_id: 2 }
  let(:rel3) { double 'relationship 3', whatcd_score: 1000, similar_artist_id: 3 }
  let(:artist0) { OpenStruct.new(id: 1, last_played_at: Time.new(2000, 02, 24, 2, 2, 0)) }
  let(:artist1) { OpenStruct.new(id: 2, last_played_at: nil) }
  let(:artist2) { OpenStruct.new(id: 3, last_played_at: Time.new(2000, 02, 24, 2, 3, 0)) }

  describe 'when assigning similarity scores to artists' do
    
    subject(:normalizer) { described_class.new([artist0, artist1, artist2]) }
    
    it 'assigns a score equal to the proportion the total whatcd_score for the artist is out of the maximum whatcd_score' do
      normalizer.assign_similarity_scores([rel0, rel1, rel2, rel3])

      expect(artist0.similarity_score).to eq(0.2)
      expect(artist1.similarity_score).to eq(0.4)
      expect(artist2.similarity_score).to eq(1.0)
    end
  end

  describe 'when assigning last played scores to artists' do
    context 'when at least one artist has been played' do
    
      subject(:normalizer) { described_class.new([artist0, artist1, artist2]) }
      
      context 'when artist has a last playback' do
        it 'assigns a score of 0 to the artist played most recently' do
          normalizer.assign_last_played_scores
          
          expect(artist2.last_played_score).to eq(0.0)
        end

        it 'assigns a score of 1 to the artist played least recently' do
          normalizer.assign_last_played_scores
          
          expect(artist0.last_played_score).to eq(1.0)
        end
      end

      context 'when artist does not have a last playback' do
        it 'does not assign a score' do
          normalizer.assign_last_played_scores
          
          expect(artist1.last_played_score).to be_nil
        end
      end
    end
    context 'when no artists have been played before' do
      
      subject(:normalizer) { described_class.new([artist1]) }
      
      it 'does not assign scores to any artists' do
        normalizer.assign_last_played_scores
        
        expect(artist1.last_played_score).to be_nil
      end
    end
    context 'when only one artist has been played before' do
      subject(:normalizer) { described_class.new([artist0]) }
      it 'does not assign scores to any artists' do
        normalizer.assign_last_played_scores
        
        expect(artist0.last_played_score).to be_nil
      end
    end
  end
end
