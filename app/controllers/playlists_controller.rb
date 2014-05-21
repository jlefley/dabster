class PlaylistsController < ApplicationController

  def show
    @playlist = Dabster::Playlist.first!(id: params[:id])
  end

  def play
    playlist = Dabster::Playlist.first!(id: params[:id])
    $playback_proxy.play_playlist(playlist)
    redirect_to playback_path
  end
  
end
