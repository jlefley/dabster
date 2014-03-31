module Dabster
  class ArtistLibraryItemRelationshipsController < ApplicationController
    def create
      rel = ArtistLibraryItemRelationship.create(create_params)
      flash[:notice] = 'Artist library item relationship created'
      redirect_to library_item_path(id: rel.library_item_id)
    end

    def destroy
      rel = ArtistLibraryItemRelationship.first!(destroy_params)
      rel.destroy
      flash[:notice] = 'Artist library item relationship destroyed'
      redirect_to Library::Item.first!(id: rel.library_item_id)
    rescue Sequel::NoMatchingRow
      redirect_to artist_library_item_relationships_path
    end

    def index
      @artist_library_item_relationships = ArtistLibraryItemRelationship.no_library_item.all
    end

    private

    def destroy_params
      p = params.require(:relationship)
      {
        library_item_id: p.fetch(:library_item_id).to_i,
        artist_id: p.fetch(:artist_id).to_i,
        type: p.fetch(:type),
        group_artist: false
      }
    end

    def create_params
      destroy_params.merge(confidence: 1.0)
    end
  end
end
