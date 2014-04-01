require 'unit_spec_helper'
require 'whatcd/torrent_group_source'
require 'whatcd/error'
require 'ostruct'

describe Dabster::Whatcd::TorrentGroupSource do

  subject(:source) { described_class.new api, api_cache, artist_source, OpenStruct, OpenStruct }

  let(:artist_source) { double 'artist source' }
  let(:api) { double 'api connection' }
  let(:api_cache) { double 'api cache' }

  describe 'when retrieving torrent group' do

    let(:torrent_group_response) { { group: { id: 55, name: 'name', musicInfo: { artists: [{ id: 1 }], dj: [{ id: 3 }] } } } }
    let(:artist) { OpenStruct.new(id: 2, torrentgroup: [{ groupId: 55, tags: ['tag'], groupName: 'name' }]) }

    describe 'when specified filter contains id key' do

      describe 'when torrent group response for specified id is in cache' do
        describe 'when torrent group has at least one artist' do
          before { allow(api_cache).to receive(:torrent_group).with(id: 55).and_return(torrent_group_response) }
          
          describe 'when artist response contains matching torrent group' do
            before { allow(artist_source).to receive(:find).with(id: 1).and_return(artist) }

            it 'returns group with all fields from cached torrent group' do
              expect(source.find(id: 55).musicInfo).to eq(artists: [{ id: 1 }], dj: [{ id: 3 }])
              expect(source.find(id: 55).id).to eq(55)
            end

            it 'returns group with tags from torrent group contained in artist matching any artist id in group with specified id' do
              expect(source.find(id: 55).tags).to eq(['tag'])
            end
          end
            
          describe 'when artist does not have torrent group with specified id' do
            before { allow(artist_source).to receive(:find).and_return(OpenStruct.new(torrentgroup: [])) }
            
            it 'raises error' do
              expect { source.find(id: 55) }.to raise_error(Dabster::Whatcd::Error)
            end
          end
        
          describe 'when artist torrent group name does not match torrent group name' do
            before { allow(artist_source).to receive(:find).and_return(OpenStruct.new(torrentgroup: [{ groupId: 55, name: 'other' }])) }

            it 'raises error' do
              expect { source.find(id: 55) }.to raise_error(Dabster::Whatcd::Error)
            end
          end

        end

        describe 'when torrent group does not have at least on artist' do
          before { allow(api_cache).to receive(:torrent_group).with(id: 55).and_return(group: { musicInfo: {} }) }
          
          it 'raises error' do
            expect { source.find(id: 55) }.to raise_error(Dabster::Whatcd::Error)
          end
        end

      end

      describe 'when torrent group response for specified id is not in cache' do
        before do
          allow(api_cache).to receive(:cache_torrent_group)
          allow(api_cache).to receive(:torrent_group).and_return(nil)
        end
        
        describe 'when torrent group has at least one artist' do
          before { allow(api).to receive(:make_request).with(action: 'torrentgroup', id: 55).and_return(torrent_group_response) }

          describe 'when artist response contains matching torrent group' do
            before { allow(artist_source).to receive(:find).with(id: 1).and_return(artist) }

            it 'returns group with all fields from fetched torrent group' do
              expect(source.find(id: 55).musicInfo).to eq(artists: [{ id: 1 }], dj: [{ id: 3 }])
              expect(source.find(id: 55).id).to eq(55)
            end

            it 'caches torrent group response' do
              expect(api_cache).to receive(:cache_torrent_group).with(id: 55, response: torrent_group_response)
              
              source.find(id: 55)
            end
            
            it 'returns group with tags from torrent group contained in artist matching any artist id in group with specified id' do
              expect(source.find(id: 55).tags).to eq(['tag'])
            end

          end
       
          describe 'when artist does not have torrent group with specified id' do
            before { allow(artist_source).to receive(:find).and_return(OpenStruct.new(torrentgroup: [])) }
            
            it 'raises error' do
              expect { source.find(id: 55) }.to raise_error(Dabster::Whatcd::Error)
            end
          end
        
          describe 'when artist torrent group name does not match torrent group name' do
            before { allow(artist_source).to receive(:find).and_return(OpenStruct.new(torrentgroup: [{ groupId: 55, name: 'other' }])) }

            it 'raises error' do
              expect { source.find(id: 55) }.to raise_error(Dabster::Whatcd::Error)
            end
          end
        end
        
        describe 'when torrent group does not have at least on artist' do
          before { allow(api).to receive(:make_request).and_return(group: { musicInfo: {} }) }
          
          it 'raises error' do
            expect { source.find(id: 55) }.to raise_error(Dabster::Whatcd::Error)
          end
        end
      
      end

    end
  
    describe 'when specified filter contains hash key' do
      before do
        allow(api_cache).to receive(:cache_torrent_group)
      end
      
      describe 'when torrent group has at least one artist' do
        before { allow(api).to receive(:make_request).with(action: 'torrentgroup', hash: 'HASH').and_return(torrent_group_response) }

        describe 'when artist response contains matching torrent group' do
          before { allow(artist_source).to receive(:find).with(id: 1).and_return(artist) }

          it 'returns group with all fields from fetched torrent group' do
            expect(source.find(hash: 'HASH').musicInfo).to eq(artists: [{ id: 1 }], dj: [{ id: 3 }])
            expect(source.find(hash: 'HASH').id).to eq(55)
          end

          it 'caches torrent group response' do
            expect(api_cache).to receive(:cache_torrent_group).with(id: 55, response: torrent_group_response)
            
            source.find(hash: 'HASH')
          end
          
          it 'returns group with tags from torrent group contained in artist matching any artist id in group with specified id' do
            expect(source.find(hash: 'HASH').tags).to eq(['tag'])
          end

        end
     
        describe 'when artist does not have torrent group with specified id' do
          before { allow(artist_source).to receive(:find).and_return(OpenStruct.new(torrentgroup: [])) }
          
          it 'raises error' do
            expect { source.find(hash: 'HASH') }.to raise_error(Dabster::Whatcd::Error)
          end
        end
      
        describe 'when artist torrent group name does not match torrent group name' do
          before { allow(artist_source).to receive(:find).and_return(OpenStruct.new(torrentgroup: [{ groupId: 55, name: 'other' }])) }

          it 'raises error' do
            expect { source.find(hash: 'HASH') }.to raise_error(Dabster::Whatcd::Error)
          end
        end
      end
      
      describe 'when torrent group does not have at least on artist' do
        before { allow(api).to receive(:make_request).and_return(group: { musicInfo: {} }) }
        
        it 'raises error' do
          expect { source.find(hash: 'HASH') }.to raise_error(Dabster::Whatcd::Error)
        end
      end
    
    end

    describe 'when specified filter contains both hash and id keys' do
      it 'raises error' do
        expect { source.find(id: 1, hash: 'HASH') }.to raise_error(ArgumentError)
      end
    end

    describe 'when specified filter does not contain hash or id keys' do
      it 'raises error' do
        expect { source.find({}) }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'when searching for torrent groups' do
    it 'returns results of search response as array of groups' do
      allow(api).to receive(:make_request).with(action: 'browse', 'filter_cat[1]' => 1, groupname: 'abc').and_return(results: 'results')
      
      expect(source.search(groupname: 'abc').results).to eq('results')
    end
  end

end
