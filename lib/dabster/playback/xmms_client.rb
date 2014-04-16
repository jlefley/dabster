require 'xmmsclient'

module Dabster
  module Playback
    module XMMSClient

      attr_reader :underlying_client

      def initialize
        @underlying_client = Xmms::Client.new
      end

      def connect(host_path)
        underlying_client.connect(host_path)
      rescue Xmms::Client::ClientError
        raise(Dabster::Error, "Failed to connect to XMMS2 daemon at #{host_path}")
      end

      def playback_start
        underlying_client.playback_start.notifier do
          puts 'playback started'
        end
      end

      def playback_stop
        underlying_client.playback_stop.notifier do
          puts 'playback stoped'
        end
      end

      def clear_playlist
        underlying_client.playlist.clear.notifier do
          puts 'playlist cleared'
        end
      end

      def queue_item(item)
        underlying_client.playlist.add_entry(item.path).notifier do
          puts "added #{item.path}"
        end
      end

      def io_fd
        underlying_client.id_fd
      end

      def on_playlist_position_changed
        underlying_client.broadcast_playlist_current_pos.notifier do |res|
          true
        end
      end

    end
  end
end
