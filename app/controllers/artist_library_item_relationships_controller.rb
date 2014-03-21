class ArtistLibraryItemRelationshipsController < ApplicationController
  def create
    rel = ArtistLibraryItemRelationship.create(create_params)
    flash[:notice] = 'Artist library item relationship created'
    redirect_to library_item_path(id: rel.library_item_id)
  end

  def destroy
    puts destroy_params
    rel = ArtistLibraryItemRelationship.first!(destroy_params)
    rel.destroy
    flash[:notice] = 'Artist library item relationship destroyed'
    redirect_to library_item_path(id: rel.library_item_id)
  end

  def destroy_params
    p = params.require(:relationship)
    { library_item_id: p.fetch(:library_item_id).to_i, artist_id: p.fetch(:artist_id).to_i, type: p.fetch(:type), group_artist: false }
  end

  def create_params
    destroy_params.merge(confidence: 1.0)
  end
end
