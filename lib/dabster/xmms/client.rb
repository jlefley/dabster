require 'xmmsclient'
require 'eventmachine'

module Dabster
  module Xmms
    class Client

      def initialize
        # Create a client
        @xmms = ::Xmms::Client.new('dabster')
        
        # Connect to xmms daemon
        @xmms.connect(ENV['XMMS_PATH'])

        # Watch for async events
=begin
        EM.next_tick do
          EM.watch(@xmms.io_fd, Connection, @xmms) { |c| c.notify_readable = true }
        end
=end
      rescue ::Xmms::Client::ClientError
        raise(Dabster::Error, "Failed to connect to XMMS2 daemon at #{ENV['XMMS_PATH']}")
      end

      def stop_playback
        @xmms.playback_stop.wait
      end

      def clear_playlist
        @xmms.playlist.clear.wait
      end

      def add_entry(path)
        @xmms.playlist.add_entry("file://#{path}").wait
      end

      def set_next_position(position)
        @xmms.playlist_set_next(position).wait
      end

      def start_playback
        @xmms.playback_start.wait
      end

    end
  end
end
