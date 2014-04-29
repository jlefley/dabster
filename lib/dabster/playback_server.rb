require 'amqp'

module Dabster
  class PlaybackServer

    def start
      puts 'Starting playback server'
      EM.run do
        @amqp = AMQP.connect(host: '127.0.0.1')
        channel = AMQP::Channel.new(@amqp)

        play_queue = AMQP::Queue.new(channel, 'dabster.playbackserver.play', auto_delete: true, exclusive: true)
        rpc_queue = AMQP::Queue.new(channel, 'dabster.playbackserver.rpc', auto_delete: true, exclusive: true)

        play_queue.subscribe do |metadata, payload|
          puts "Received playlist to play, playlist_id: #{payload}"
          @current_playlist = Dabster::Playlist.first!(id: payload.to_i)
        end

        rpc_queue.subscribe do |metadata, payload|
          puts "Received RPC request: #{payload}"
          message = { playlist_id: @current_playlist.id }.to_json
          channel.default_exchange.publish(message, routing_key: metadata.reply_to, correlation_id: metadata.message_id)
        end
      end

      Signal.trap('INT') { stop }
    end

    def stop
      puts 'Stoping playback server'
      return unless EM.reactor_running?
      @amqp.close { EM.stop }
    end

  end
end
