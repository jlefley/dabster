module Dabster
  class PlaybackController < ApplicationController
    def show
      reply_queue = $rabbitmq_channel.queue('', auto_delete: true, exclusive: true)

      lock = Mutex.new
      condition = ConditionVariable.new
      correlation_id = SecureRandom.uuid

      # Subscribe to response queue
      status = nil
      consumer = reply_queue.subscribe do |delivery_info, properties, payload|
        if properties.correlation_id == correlation_id
          status = OpenStruct.new(JSON.parse(payload, symbolize_names: true))
          lock.synchronize { condition.signal }
          delivery_info.consumer.cancel
        end
      end

      # Send request
      $rabbitmq_channel.default_exchange.publish('get.status',
                                       routing_key: 'dabster.playbackserver.rpc',
                                       message_id: correlation_id,
                                       reply_to: reply_queue.name)

      # Block until the response callback is executed
      Timeout.timeout(2) do
        lock.synchronize { condition.wait(lock) }
      end
      
      playlist = Dabster::Playlist.first(id: status.playlist_id)
      
      if status.state == 'empty' || playlist.nil?
        @status = 'Current playlist not present'
      else
        @items = playlist.items
        @current_position = playlist.current_position
        @status = "Now playing: #{playlist.current_item.title} - #{playlist.current_item.artist}"
      end
    end

    def pause
      $rabbitmq_channel.default_exchange.publish('pause', routing_key: 'dabster.playbackserver.control')
      render json: true
    end

    def play
      $rabbitmq_channel.default_exchange.publish('play', routing_key: 'dabster.playbackserver.control')
      render json: true
    end

    def next
      $rabbitmq_channel.default_exchange.publish('next', routing_key: 'dabster.playbackserver.control')
      render json: true
    end

  end
end
