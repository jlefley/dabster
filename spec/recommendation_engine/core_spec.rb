require 'unit_spec_helper'
require 'recommendation_engine_core'

describe Dabster::RecommendationEngineCore do
  def val(params) OpenStruct.new(params); end

  describe 'when weighing artist similarity' do
    let(:rel0) { val(whatcd_score: 100, similar_artist_id: 1, distance: 1) }
    let(:rel1) { val(whatcd_score: 100, similar_artist_id: 1, distance: 1) }
    let(:rel2) { val(whatcd_score: 400, similar_artist_id: 2, distance: 1) }
    let(:rel3) { val(whatcd_score: 1000, similar_artist_id: 3, distance: 1) }
    let(:rel4) { val(whatcd_score: nil, similar_artist_id: 4, distance: 0) }
    let(:artist0) { val(id: 1) }
    let(:artist1) { val(id: 2) }
    let(:artist2) { val(id: 3) }
    let(:artist4) { val(id: 4) }
    
    let(:weighted_artists) do
      described_class.weigh_artist_similarity([artist0, artist1, artist2, artist4], [rel0, rel1, rel2, rel3, rel4])
    end
   
    context 'artists having relationships with distance greater than 0' do 

      it 'assigns a score equal to the proportion the total whatcd_score for the artist is out of the maximum whatcd_score' do
        expect(weighted_artists[0].similarity_score).to be_within(0.01).of(0.2)
        expect(weighted_artists[1].similarity_score).to be_within(0.01).of(0.4)
        expect(weighted_artists[2].similarity_score).to be_within(0.01).of(1.0)
      end
    end
    context 'artists having relationships with distance of 0' do
      it 'assigns score of 1' do
        expect(weighted_artists[3].similarity_score).to eq(1.0)
      end
    end

    it 'copies values' do
      expect(weighted_artists[0].id).to eq(1)
      expect(weighted_artists[1].id).to eq(2)
      expect(weighted_artists[2].id).to eq(3)
      expect(weighted_artists[3].id).to eq(4)
    end
  end

  describe 'when weighing artist last playback' do
    let(:artist0) { val(id: 1, last_played_at: Time.new(2000, 02, 24, 2, 2, 0)) }
    let(:artist1) { val(id: 2, last_played_at: nil) }
    let(:artist2) { val(id: 3, last_played_at: Time.new(2000, 02, 24, 2, 3, 0)) }

    context 'when at least one specified artist has been played' do
      let(:weighted_artists) { described_class.weigh_artist_last_playback([artist0, artist1, artist2]) }
      
      context 'when artist does not have a last playback' do
        it 'assigns a score of 0 to the artist played most recently' do
          expect(weighted_artists[2]).to eq(val(id: 3, last_played_at: artist2.last_played_at, last_played_score: 0.0))
        end
        it 'assigns a score of 1 to the artist played least recently' do
          expect(weighted_artists[0]).to eq(val(id: 1, last_played_at: artist0.last_played_at, last_played_score: 1.0))
        end
      end

      context 'when artist does not have a last playback' do
        it 'does not assign a score' do
          expect(weighted_artists[1]).to eq(val(id: 2, last_played_at: artist1.last_played_at, last_played_score: nil))
        end
      end

    end

    context 'when no specified artists have been played before' do
      it 'does not assign scores to any artists' do
        weighted_artists = described_class.weigh_artist_last_playback([artist1])
        expect(weighted_artists).to eq([val(id: 2, last_played_at: artist1.last_played_at, last_played_score: nil)])
      end
    end
    context 'when only one specified artist has been played before' do
      it 'assigns a score of 0 to the played artist' do
        weighted_artists = described_class.weigh_artist_last_playback([artist0, artist1])
        expect(weighted_artists[0]).to eq(val(id: 1, last_played_at: artist0.last_played_at, last_played_score: 0))
      end
    end

  end

  describe 'when sorting artists' do
    let(:artist0) { double 'artist 0', similarity_score: 0.2, last_played_score: 0.8 }
    let(:artist1) { double 'artist 1', similarity_score: 0.7, last_played_score: 0.1 }
    let(:artist2) { double 'artist 2', similarity_score: 0.5, last_played_score: nil }
    let(:artist3) { double 'artist 3', similarity_score: 0.1, last_played_score: nil }

    context 'when some specified artists have not been played before' do
      it 'returns artists sorted by highest similarity score out of artists that have not been played before' do
        expect(described_class.sort_artists([artist1, artist2, artist3])).to eq([artist2, artist3])
      end
    end

    context 'when all specified artists have been played before' do
      it 'returns artists sorted by highest average last played score and similarity' do
        expect(described_class.sort_artists([artist1, artist0])).to eq([artist0, artist1])
      end
    end

  end

end
