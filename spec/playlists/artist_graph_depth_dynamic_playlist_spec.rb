require 'unit_spec_helper'
require 'errors'
require 'playlists/artist_graph_depth_dynamic_playlist'

describe Dabster::Playlists::ArtistGraphDepthDynamicPlaylist do

  let(:playlist) { double 'underlying playlist' }
  let(:recommender) { double 'artist/item recommender' }

  subject(:dynamic_playlist) { described_class.new(playlist, recommender) }

  describe 'when next item is selected' do

    context 'when constructed with playlist having initial artist' do

      before { allow(playlist).to receive(:initial_artist).and_return('initial_artist') }

      context 'when no items have been selected' do

        before { allow(playlist).to receive(:last_played_item).and_return(nil) }

        context 'when initial artist has items available for selection' do

          before { allow(recommender).to receive(:select_item).with('initial_artist').and_return('item') }

          it 'returns item' do
            allow(playlist).to receive(:add_item)

            expect(dynamic_playlist.next_item).to eq('item')
          end

          it 'adds item to playlist' do
            expect(playlist).to receive(:add_item).with('item')

            dynamic_playlist.next_item
          end

        end

        context 'when initial artist has no items available for selection' do

          before { allow(recommender).to receive(:select_item).with('initial_artist').and_return(nil) }

          it 'raises error' do
            expect { dynamic_playlist.next_item }.to raise_error(Dabster::PlaylistError)
          end

        end

      end

      context 'when item has been selected' do

        before { allow(playlist).to receive(:last_played_item).and_return('last_item') }

        context 'when last played item has artists available for selection' do

          before { allow(recommender).to receive(:select_artists_by_item).with('last_item').and_return(['artist0', 'artist1']) }

          context 'when first selected artist has items available for selection' do

            before { allow(recommender).to receive(:select_item).with('artist0').and_return('item') }

            it 'returns item selected using first selected artist' do
              allow(playlist).to receive(:add_item)

              expect(dynamic_playlist.next_item).to eq('item')
            end
            
            it 'adds item to playlist' do
              expect(playlist).to receive(:add_item).with('item')

              dynamic_playlist.next_item
            end

          end

          context 'when first selected artist has no items available for selection' do

            before { allow(recommender).to receive(:select_item).with('artist0').and_return(nil) }

            context 'when subsequent selected artists have items available for selection' do

              before { allow(recommender).to receive(:select_item).with('artist1').and_return('item') }

              it 'returns item selected using first selected artist' do
                allow(playlist).to receive(:add_item)

                expect(dynamic_playlist.next_item).to eq('item')
              end

              it 'adds item to playlist' do
                expect(playlist).to receive(:add_item).with('item')

                dynamic_playlist.next_item
              end

            end 

            context 'when subsequent selected artists do not have items available for selection' do

              before { allow(recommender).to receive(:select_item).with('artist1').and_return(nil) }

              it 'raises error' do
                expect { dynamic_playlist.next_item }.to raise_error(Dabster::PlaylistError)
              end

            end

          end
          
        end

        context 'when last played item has no artists available for selection' do

          before { allow(recommender).to receive(:select_artists_by_item).with('last_item').and_return([]) }

          it 'raises error' do
            expect { dynamic_playlist.next_item }.to raise_error(Dabster::PlaylistError)
          end

        end
        
      end

    end

  end

end
