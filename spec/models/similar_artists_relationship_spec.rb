require 'db_spec_helper'

describe Dabster::SimilarArtistsRelationship do
  subject(:relationship) { described_class.new(whatcd_score: 200, artist_id: 5, similar_artist_id: 2) }

  it { should be_valid }
  
  describe 'when whatcd_score is missing' do
    before { relationship.whatcd_score = '' }
    it { should_not be_valid }
  end
  describe 'when artist_id is missing' do
    before { relationship.artist_id = nil }
    it { should_not be_valid }
  end
  describe 'when similar_artist_id is missing' do
    before { relationship.similar_artist_id = nil }
    it { should_not be_valid }
  end
end
