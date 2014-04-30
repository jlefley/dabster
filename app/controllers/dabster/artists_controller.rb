module Dabster
  class ArtistsController < ApplicationController
    def show
      @artist = Dabster::Artist.first!(id: params[:id])
      @groups_by_type = @artist.groups_by(:type)
      @items_by_type = @artist.items_by(:type, group_artist: false)
      @similar_artists = @artist.similar_artist_relationships_ordered_by_score
    end

    def start_playlist
      artist = Dabster::Artist.first!(id: params[:id])
      playlist = Dabster::Playlist.create(current_position: 0)
      playlist.add_initial_artist(artist)
      $rabbitmq_channel.default_exchange.publish(playlist.id.to_s, routing_key: 'dabster.playbackserver.play')
      redirect_to playback_path
    end
  end
end
