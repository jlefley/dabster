class ArtistsController < ApplicationController
  def show
    @artist = Dabster::Artist.first!(id: params[:id])
    @groups_by_type = @artist.groups_by(:type)
    @items_by_type = @artist.items_by(:type, group_artist: false)
    @similar_artists = @artist.similar_artist_relationships_ordered_by_score
  end

  def start_playlist
    artist = Dabster::Artist.first!(id: params[:id])
    playlist = Dabster::Playlist.create
    playlist.initialize_with_artist(artist)
    $playback_proxy.play_playlist(playlist)
    redirect_to playback_path
  end
end
