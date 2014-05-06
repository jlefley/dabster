require 'amqp'

module Dabster
  class PlaybackServer

    attr_reader :client

    def initialize(client)
      @client = client

      client.on_current_position_changed do |new_position|
        puts "[PlaybackServer] Current position changed, new position: #{new_position}"
        @current_playlist.update(current_position: new_position)
      end

      client.on_playback_started do |entry_id|
        puts "[PlaybackServer] Started entry playback, entry id: #{entry_id}"
        @entries.select { |e| e[0] == entry_id }.first[1].add_playback

        if client.current_position == @entries.length - 1
          puts '[PlaybackServer] Queuing entry'
          item = @current_playlist.next_item
          client.add_entry(item.path)
          @entries << [client.entry_ids.last, item]
        end
      end

      client.on_playback_status_changed do |new_status|
        puts "[PlaybackServer] Playback status changed to #{new_status}"
        message = { state: new_status, playlist_id: @current_playlist.id }.to_json
        #@status_exchange.publish(message)
      end
    end
    
    def start
      puts '[PlaybackServer] Starting playback server'

      @current_playlist = nil
      @entries = []
      client.clear_playlist

      EM.run do
        @amqp = AMQP.connect(host: '127.0.0.1')
        channel = AMQP::Channel.new(@amqp)

        play_queue = AMQP::Queue.new(channel, 'dabster.playbackserver.play', auto_delete: true, exclusive: true)
        control_queue = AMQP::Queue.new(channel, 'dabster.playbackserver.control', auto_delete: true, exclusive: true)
        rpc_queue = AMQP::Queue.new(channel, 'dabster.playbackserver.rpc', auto_delete: true, exclusive: true)
        @status_exchange = channel.fanout('dabster.playbackserver.status')

        play_queue.subscribe do |metadata, playlist_id|
          puts "[PlaybackServer] Received playlist to play, playlist_id: #{playlist_id}"
          @current_playlist = Dabster::Playlist.first!(id: playlist_id.to_i)
          client.stop_playback
          client.clear_playlist
          
          @current_playlist.items.each { |item| client.add_entry(item.path) }
          @entries = client.entry_ids.each_with_index.map { |id, i| [id, @current_playlist.items[i]] }
          
          client.start_playback
          puts '[PlaybackServer] Started playlist playback'
        end

        rpc_queue.subscribe do |metadata, request|
          puts "[PlaybackServer] Received RPC request: #{request}"
          if @current_playlist.nil?
            message = { state: :empty }.to_json
          else
            message = { state: client.playback_status, playlist_id: @current_playlist.id }.to_json
          end
          channel.default_exchange.publish(message, routing_key: metadata.reply_to, correlation_id: metadata.message_id)
        end

        control_queue.subscribe do |metadata, command|
          puts "[PlaybackServer] Received #{command} command"
          case command
          when 'pause'
            client.pause_playback
          when 'play'
            client.start_playback
          when 'next'
            client.play_next_entry
          end
        end

        Signal.trap('INT') { stop }
      end
    end

    def stop
      puts '[PlaybackServer] Stoping playback server'
      #return unless EM.reactor_running? and @amqp
      @amqp.close { EM.stop }
    end

  end
end
