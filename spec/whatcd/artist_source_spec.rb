require 'unit_spec_helper'
require 'whatcd/artist_source'
require 'ostruct'

describe Dabster::Whatcd::ArtistSource do
  subject(:source) { described_class.new api, api_cache, OpenStruct }

  let(:api_cache) { double 'api cache' }
  let(:api) { double 'api connection ' }

  let(:artist_response) { { id: 23, name: 'name' } }

  describe 'when retrieving artist' do
    describe 'when specified filter contains id key' do

      describe 'when artist response for specified id is in cache' do
        before { allow(api_cache).to receive(:artist).with(id: 23).and_return(artist_response) }

        it 'returns artist with fields from cached response' do
          expect(source.find(id: 23).id).to eq(23)
          expect(source.find(id: 23).name).to eq('name')
        end
      end

      describe 'when artist response for specified id is not in cache' do
        before do
          allow(api_cache).to receive(:artist).and_return(nil)
          allow(api).to receive(:make_request).with(action: 'artist', id: 23).and_return(artist_response)
          allow(api_cache).to receive(:cache_artist)
        end
        it 'returns artist with fields from fetched response' do
          expect(source.find(id: 23).id).to eq(23)
          expect(source.find(id: 23).name).to eq('name')
        end
        it 'caches fetched response' do
          expect(api_cache).to receive(:cache_artist).with(id: 23, response: artist_response)
          
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
