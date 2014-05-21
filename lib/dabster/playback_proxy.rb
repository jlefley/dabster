module Dabster
  class PlaybackProxy

    attr_reader :current_playlist

    def initialize(client)
      @client = client

      @client.on_current_position_changed do |new_position|
        puts "[PlaybackServer] Current position changed, new position: #{new_position}"
        @current_playlist.update(current_position: new_position)
      end

      @client.on_playback_started do |entry_id|
        puts "[PlaybackServer] Started entry playback, entry id: #{entry_id}"
        @entries.select { |e| e[0] == entry_id }.first[1].add_playback

        if @client.current_position == @entries.length - 1
          puts '[PlaybackServer] Queuing entry'
          item = @current_playlist.next_item
          @client.add_entry(item.path)
          @entries << [@client.entry_ids.last, item]
        end
      end

      @client.on_playback_status_changed do |new_status|
        puts "[PlaybackServer] Playback status changed to #{new_status}"
      end
    end

    def reset
      @current_playlist = nil
      @entries = []
      @client.clear_playlist
    end

    def pause_playback
      @client.pause_playback
    end

    def start_playback
      @client.start_playback
    end
    
    def play_next_entry
      @client.play_next_entry
    end

    def play_previous_entry
      @client.play_previous_entry
    end

    def status
      if @current_playlist.nil?
        :empty
      else
        @client.playback_status
      end
    end

    def play_playlist(playlist)
      puts "[PlaybackServer] Received playlist to play: #{playlist.inspect}"
      @current_playlist = playlist
      @client.stop_playback
      @client.clear_playlist
      
      @current_playlist.items.each { |item| @client.add_entry(item.path) }
      @entries = @client.entry_ids.each_with_index.map { |id, i| [id, @current_playlist.items[i]] }
      
      @client.start_playback
      puts '[PlaybackServer] Started playlist playback'
    end

  end
end
