module Dabster
  class ArtistsController < ApplicationController
    def show
      @artist = Artist.first!(id: params[:id])
      @groups_by_type = @artist.groups_by(:type)
      @items_by_type = @artist.items_by(:type, group_artist: false)
      @similar_artists = @artist.similar_artist_relationships_ordered_by_score
    end
  end
end
