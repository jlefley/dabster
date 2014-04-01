require 'unit_spec_helper'
require 'whatcd/similar_artists_source'
require 'ostruct'

describe Dabster::Whatcd::SimilarArtistsSource do
  subject(:source) { described_class.new api, api_cache, OpenStruct }

  let(:api_cache) { double 'api cache' }
  let(:api) { double 'api connection ' }

  let(:similar_artists) { [{ id: 23, name: 'name', score: 200 }] }

  describe 'when retrieving similar artists' do
    describe 'when specified filter contains id key' do

      describe 'when similar artists response for specified id is in cache' do
        before { allow(api_cache).to receive(:similar_artists).with(id: 23).and_return(similar_artists) }

        it 'returns similar artists instances with fields from cached response' do
          expect(source.find(id: 23).first.id).to eq(23)
          expect(source.find(id: 23).first.score).to eq(200)
        end
        
      end

      describe 'when similar artists response for specified id is not in cache' do
        before do
          allow(api_cache).to receive(:similar_artists).and_return(nil)
          allow(api_cache).to receive(:cache_similar_artists)
          allow(api).to receive(:make_request).with(action: 'similar_artists', id: 23, limit: 1000000).and_return(similar_artists)
        end

        it 'returns similar artists instances with fields from fetched response' do
          expect(source.find(id: 23).first.score).to eq(200)
          expect(source.find(id: 23).first.id).to eq(23)
        end

        it 'caches fetched response' do
          expect(api_cache).to receive(:cache_similar_artists).with(id: 23, response: similar_artists)
          
          source.find(id: 23)
        end

      end

    end

    describe 'when specified filter does not contain id key' do
      it 'raises error' do
        expect { source.find({}) }.to raise_error(ArgumentError)
      end
    end
  end

end
