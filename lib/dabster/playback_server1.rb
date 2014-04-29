require 'glib2'
require 'xmmsclient'
require 'xmmsclient_glib'

module Dabster
  class PlaybackServer1

    attr_reader :main, :client, :playlist

    def initialize(playlist)
      @main, @client, @playlist = GLib::MainLoop.new(nil, false), Xmms::Client.new('dabster'), playlist
    end

    def run
      client.connect(ENV['XMMS_PATH'])
      client.add_to_glib_mainloop
      
      # Reset server
      stop_playback
      clear_playlist

      # Add first song
      add_item
      # Add next song
      add_item

      # Start playing first song
      start_playback

      # Add callback to queue song after playlist position changes
      client.broadcast_playlist_current_pos.notifier do |res|
        puts 'playlist position changed, adding song'
        puts "now playing song #{res[:position]}"
        add_item
        true
      end

      main.run
    rescue Xmms::Client::ClientError
      puts "Failed to connect to XMMS2 daemon at #{ENV['XMMS_PATH']}"
    ensure
      main.quit
    end

    def start_playback
      client.playback_start.notifier do
        puts 'playback started'
      end
    end

    def stop_playback
      client.playback_stop.notifier do
        puts 'playback stoped'
      end
    end

    def clear_playlist
      client.playlist.clear.notifier do
        puts 'playlist cleared'
      end
    end

    def add_item
      next_file = "file://#{playlist.next_item.path}"
      client.playlist.add_entry(next_file).notifier do
        puts "added #{next_file}"
      end
    end

  end
end
