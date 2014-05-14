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

  describe 'when finding relationships for artists' do
    def rel(artist, similar_artist, distance)
      { artist_id: artist.id, similar_artist_id: similar_artist.id, distance: distance, whatcd_score: 100 }
    end
    
    def relate_artists(artist_a, artist_b)
      described_class.create(artist: artist_a, similar_artist: artist_b, whatcd_score: 100)
      described_class.create(artist: artist_b, similar_artist: artist_a, whatcd_score: 100)
    end

    let!(:a) { Dabster::Artist.create(whatcd_name: 'A') }
    let!(:b) { Dabster::Artist.create(whatcd_name: 'B') }
    let!(:c) { Dabster::Artist.create(whatcd_name: 'C') }
    let!(:d) { Dabster::Artist.create(whatcd_name: 'D') }
    let!(:e) { Dabster::Artist.create(whatcd_name: 'E') }
    let!(:f) { Dabster::Artist.create(whatcd_name: 'F') }
    let!(:x) { Dabster::Artist.create(whatcd_name: 'X') }
    before do
      relate_artists(a, b)
      relate_artists(a, c)
      relate_artists(b, c)
      relate_artists(b, d)
      relate_artists(c, x)
      relate_artists(x, f)
      relate_artists(d, f)
      relate_artists(d, e)
    end
    
    context 'when a single artist is specified' do
      context 'when max distance is one' do
        it 'returns all relationships where artist matches specified artist' do
          expect(described_class.find_by_artists([a], 1)).to match_array([rel(a, b, 1), rel(a, c, 1)])
        end
      end
      context 'when max distance is two' do
        it 'returns all relationships within 2 edge traversals of specified artist' do
          expect(described_class.find_by_artists([a], 2)).to match_array(
            [rel(a, b, 1), rel(a, c, 1), rel(a, b, 2), rel(a, c, 2), rel(a, d, 2), rel(a, x, 2)]
          )
        end
      end
      context 'when max distance is three' do
        it 'returns all relationships within 3 edge traversals of specified artist' do
          expect(described_class.find_by_artists([a], 3)).to match_array(
            [rel(a, b, 1), rel(a, c, 1), rel(a, b, 2), rel(a, c, 2), rel(a, d, 2), rel(a, x, 2),
             rel(a, d, 3), rel(a, e, 3), rel(a, f, 3), rel(a, x, 3), rel(a, f, 3)]
          )
        end
      end
    end
    context 'when multiple artists are specified' do
      context 'when max distance is one' do
        it 'returns all relationships where artist matches specified artist' do
          expect(described_class.find_by_artists([a, x], 1)).to match_array(
            [rel(a, b, 1), rel(a, c, 1), rel(x, c, 1), rel(x, f, 1)]
          )
        end
      end
      context 'when max distance is two' do
        it 'returns all relationships within 2 edge traversals of specified artist' do
          expect(described_class.find_by_artists([a, x], 2)).to match_array(
            [rel(a, b, 1), rel(a, c, 1), rel(a, b, 2), rel(a, c, 2), rel(a, d, 2),
             rel(x, c, 1), rel(x, f, 1), rel(x, b, 2), rel(x, d, 2)]
          )
        end
      end
      context 'when max distance is three' do
        it 'returns all relationships within 3 edge traversals of specified artist' do
          expect(described_class.find_by_artists([a, x], 3)).to match_array(
            [rel(a, b, 1), rel(a, c, 1), rel(a, b, 2), rel(a, c, 2), rel(a, d, 2),
             rel(a, d, 3), rel(a, e, 3), rel(a, f, 3), rel(a, f, 3),
             rel(x, c, 1), rel(x, f, 1), rel(x, b, 2), rel(x, d, 2),
             rel(x, b, 3), rel(x, d, 3), rel(x, b, 3), rel(x, e, 3)]
          )
        end
      end
    end
  end
end
