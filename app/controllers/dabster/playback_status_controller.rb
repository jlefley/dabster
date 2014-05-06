module Dabster
  class PlaybackStatusController < ApplicationController
    include ActionController::Live

    def show
      response.headers['Content-Type'] = 'text/event-stream'
      exchange = $rabbitmq_channel.fanout('dabster.playbackserver.status')
      queue = $rabbitmq_channel.queue('', auto_delete: true).bind(exchange)
      consumer = queue.subscribe(block: true) do |delivery_info, metadata, payload|
        puts "received status update: #{payload}"
        send_update(payload)
      end
    rescue IOError
      puts 'io error'
    ensure
      puts 'closing'
      consumer.cancel
      response.stream.close
    end

    private

    def send_update(data)
      response.stream.write "event: status-update\n"
      response.stream.write "data: #{data.to_json}\n\n"
    end

  end
end
