require 'unit_spec_helper'
require 'services/similar_artists_service'
require 'ostruct'

describe SimilarArtistsService do

  subject(:service) { described_class.new artist_class }

  let(:artist_class) { double 'artist class' }
  let(:artist) { double 'artist', similar_artist_relationships: [] }
  let(:similar_artist) { double 'similar artist', id: 1 }
  let(:similar_artist_relationship) { double 'rel', similar_artist_id: 1 }

  describe 'when relating artist with similar artists' do
    let(:whatcd_artist_relationships) { [OpenStruct.new(id: 5, score: 200)] }

    describe 'when related artist exists' do

      before { allow(artist_class).to receive(:first).with(whatcd_id: 5).and_return(similar_artist) }

      describe 'when similarity relationship does not exist between artist and similar artist' do

        it 'adds similar artist to artist with score' do
          expect(artist).to receive(:add_similar_artist).with(similar_artist, whatcd_score: 200)

          service.relate_artists(artist, whatcd_artist_relationships)
        end 
      end

      describe 'when similarity relationship does exist between artist and similar artist' do
        
        before { allow(artist).to receive(:similar_artist_relationships).and_return([similar_artist_relationship]) }
        
        it 'updates the similarity relationship with the score' do
          expect(similar_artist_relationship).to receive(:update).with(whatcd_score: 200)
          
          service.relate_artists(artist, whatcd_artist_relationships)
        end

      end
    end
    
    describe 'when related artist does not exist' do
      
      before { allow(artist_class).to receive(:first).and_return(nil) }

      it 'does not add similar artist to artist' do
        expect(artist).not_to receive(:add_similar_artist)
        
        service.relate_artists(artist, whatcd_artist_relationships)
      end

    end
  end

end
