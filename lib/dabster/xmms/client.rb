require 'xmmsclient'
require 'eventmachine'

module Dabster
  module Xmms
    class Client

      attr_reader :xmms

      def initialize
        # Create a client
        @xmms = ::Xmms::Client.new('dabster')
        
        # Connect to xmms daemon
        @xmms.connect(ENV['XMMS_PATH'])

        # Watch for async events
        EM.next_tick do
          EM.watch(@xmms.io_fd, Connection, @xmms) { |c| c.notify_readable = true }
        end
      
      rescue ::Xmms::Client::ClientError
        raise(Dabster::Error, "Failed to connect to XMMS2 daemon at #{ENV['XMMS_PATH']}")
      end

      def stop_playback
        @xmms.playback_stop.wait
      end

      def pause_playback
        @xmms.playback_pause.wait
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
     
      def entry_ids
        @xmms.playlist.entries.wait.value
      end

      def playback_status
        convert_status(@xmms.playback_status.wait.value)
      end

      def play_next_entry
        @xmms.playlist_set_next_rel(1).wait
        @xmms.playback_tickle.wait
      end
      
      def play_previous_entry
        @xmms.playlist_set_next_rel(-1).wait
        @xmms.playback_tickle.wait
      end

      def current_position
        @xmms.playlist.current_pos.wait.value[:position]
      end

      def on_current_position_changed
        @xmms.broadcast_playlist_current_pos.notifier do |res|
          yield(res[:position])
          true
        end
      end

      def on_playback_started
        @xmms.broadcast_playback_current_id.notifier do |res|
          yield(res)
          true
        end
      end

      def on_playback_status_changed
        @xmms.broadcast_playback_status.notifier do |res|
          yield(convert_status(res))
          true
        end
      end

      private

      def convert_status(code)
        case code
        when 0
          :stopped
        when 1
          :playing
        when 2 
          :paused
        end
      end

    end
  end
end
