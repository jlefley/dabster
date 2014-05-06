module Dabster
  class PlaybackNotificationsController < ApplicationController
    include ActionController::Live

    def index
      heartbeat = Thread.new { loop { send_heartbeat; sleep 1 } }
      response.headers['Content-Type'] = 'text/event-stream'
      exchange = $rabbitmq_channel.fanout('dabster.playbackserver.notifications')
      queue = $rabbitmq_channel.queue('', auto_delete: true).bind(exchange)
      consumer = queue.subscribe do |delivery_info, metadata, payload|
        puts "received status update: #{payload}"
        send_update(payload)
      end
      heartbeat.join
    rescue IOError
      puts 'io error'
    ensure
      puts 'closing'
      heartbeat.kill if heartbeat
      consumer.cancel
      response.stream.close
    end

    private

    def send_update(data)
      response.stream.write "event: update\n"
      response.stream.write "data: #{data.to_json}\n\n"
    end

    def send_heartbeat
      response.stream.write "event: heartbeat\n"
      response.stream.write "data:\n\n"
    end

  end
end
