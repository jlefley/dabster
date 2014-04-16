module Dabster
  module Playback
    class PlaylistProxy

      attr_reader :client, :playlist

      def initialize(client, playlist)
        @client, @playlist = client, playlist
      end

      def connect_client(host_path)
        client.connect(host_path)
      end

      def reset
        client.stop_playback
        client.clear_queue
      end

      def register_client_listners
        client.on_item_playback_started { |client_id| playlist.start_item_playback(client_id: client_id) }
        client.on_item_queued { |client_id, queue_position| add_item(client_id, queue_position) }
      end

      private

      def add_item(item, client_id, queue_position)
        if queue_position != @current_position + 1
          raise(Dabster::PlaylistError, 'new item position must be one greater than current position') 
        end
        playlist.add_item(item, client_id: client_id, position: queue_position)
        @current_position += 1
      end

    end
  end
end
