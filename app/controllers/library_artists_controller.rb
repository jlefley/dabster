class LibraryArtistsController < ApplicationController
  
  def index
    @library_artists = Dabster::Library::Artist.order(:name).limit(10, 1).all
  end

  def show
    @library_artist = Dabster::Library::Artist.first! name: params[:name]
    @library_artist_albums = @library_artist.albums
  end
end
