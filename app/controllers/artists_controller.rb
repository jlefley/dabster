class ArtistsController < ApplicationController
  def new
    @library_artist = Library::Artist.first! name: params[:library_artist]
    @library_artist_albums = @library_artist.albums
  end
end
