require 'amqp'

module Dabster
  class PlaybackServer

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def start
      puts '[PlaybackServer] Starting playback server'
      EM.run do
        @amqp = AMQP.connect(host: '127.0.0.1')
        channel = AMQP::Channel.new(@amqp)

        play_queue = AMQP::Queue.new(channel, 'dabster.playbackserver.play', auto_delete: true, exclusive: true)
        rpc_queue = AMQP::Queue.new(channel, 'dabster.playbackserver.rpc', auto_delete: true, exclusive: true)

        play_queue.subscribe do |metadata, payload|
          puts "[PlaybackServer] Received playlist to play, playlist_id: #{payload}"
          @current_playlist = Dabster::Playlist.first!(id: payload.to_i)
          client.stop_playback
          client.clear_playlist
          @current_playlist.items.each do |item|
            client.add_entry(item.path)
          end
          client.set_next_position(@current_playlist.current_position)
          client.start_playback
        end

        rpc_queue.subscribe do |metadata, payload|
          puts "[PlaybackServer] Received RPC request: #{payload}"
          message = { playlist_id: @current_playlist.id }.to_json
          channel.default_exchange.publish(message, routing_key: metadata.reply_to, correlation_id: metadata.message_id)
        end
      end

      #EM.watch(@xmms.io_fd, XMMSConnection, @xmms) { |c| c.notify_readable = true }
      Signal.trap('INT') { stop }
    end

    def stop
      puts '[PlaybackServer] Stoping playback server'
      return unless EM.reactor_running? and @amqp
      @amqp.close { EM.stop }
    end

  end
end
