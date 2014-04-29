module Dabster
  class PlaylistsController < ApplicationController

    def show
      @playlist = Playlist.first!(params[:id])
    end

    def play
      @playlist = Playlist.first!(params[:id])
      channel = $rabbitmq.create_channel
      channel.default_exchange.publish(@playlist.id.to_s, routing_key: 'dabster.playbackserver.play')
      redirect_to playback_path
    end
    
  end
end
