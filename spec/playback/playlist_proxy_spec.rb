require 'unit_spec_helper'
require 'errors'
require 'playback/playlist_proxy'

describe Dabster::Playback::PlaylistProxy do

  let(:playlist) { double 'playlist' }
  let(:client) { double 'client', stop_playback: nil, clear_queue: nil }

  subject(:proxy) { described_class.new(client, playlist) }

  before do 
    allow(client).to receive(:on_item_playback_started) { |&listener| @item_playback_started_listener = listener }
    allow(client).to receive(:on_item_queued) { |&listener| @item_queued_listener = listener }
    proxy.register_client_listners
  end

  describe 'when client is connected' do
    it 'connects client providing specified host path' do
      expect(client).to receive(:connect).with('path')

      proxy.connect_client('path')
    end
  end

  describe 'when reset' do
    it 'stops playback through client' do
      expect(client).to receive(:stop_playback)

      proxy.reset
    end
    it 'clears client playback queue' do
      expect(client).to receive(:clear_queue)

      proxy.reset
    end
  end

  describe 'when client starts item playback' do
    it 'starts item playback for item with specified client id' do
      expect(playlist).to receive(:start_item_playback).with(client_id: 5)

      @item_playback_started_listener.call(5)
    end
  end

  describe 'when client playback queue position changes' do
    describe 'when new position is greater than current position' do
      describe 'when playlist does not have an item in position after specified position' do
        it 'adds next item to client playback queue' do
          #allow(generator).to receive(:next_item).and_return('next item')

          #expect(client).to receive(:queue_item).with('next item')

          #@queue_position_changed_listener.call(nil, 1)
        end
      end
      describe 'when playlist has an item in position after specified position' do
      end
    end
    describe 'when new position is less than current position' do
    end
  end

  describe 'when item is added to client playback queue' do
    before { proxy.reset }

    it 'adds the item to the playlist' do
      expect(playlist).to receive(:add_item).with()
      
      @item_queued_listener.call('item', 5, 0)
    end
  end

  describe 'when next item is queued' do
  end

  describe 'when getting io file descriptor for client' do
  end

  describe 'when getting raw client' do
  end

end
