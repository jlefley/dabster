require 'eventmachine'

module Dabster
  module Playback
    class XMMSProxyServer

      attr_reader :playlist, :client

      def initialize(playlist)
        @playlist = playlist
        @client = Dabster::Playback::XMMSClient.new
      end

      def run(xmms_path)
        # Connects to host
        xmms.connect(xmms_path)

        # Stops playback and clears xmms playlist
        xmms.reset

        # Adds all items on playlist to xmms playlist
        # Updates xmms id for each item added to xmms playlist
        # Set xmms position to playlist position
        xmms.load_playlist(playlist)

        xmms.on_playlist_position_changed do |new_position|
          # if new position = playlist length - 1 then add next playlist item to xmms playlist
        end

        # Start playback
        xmms.start_playback

        EM.run do
          Signal.trap('INT')  { stop }
          Signal.trap('TERM') { stop }
          EM.watch(client.io_fd, XMMSConnection, client.underlying_client) { |c| c.notify_readable = true }
        end
      end

    end
  end
end
