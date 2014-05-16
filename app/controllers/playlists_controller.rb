class PlaylistsController < ApplicationController

  def show
    @playlist = Dabster::Playlist.first!(id: params[:id])
  end

  def play
    playlist = Dabster::Playlist.first!(id: params[:id])
    $rabbitmq_channel.default_exchange.publish(playlist.id.to_s, routing_key: 'dabster.playbackserver.play')
    redirect_to playback_path
  end
  
end
