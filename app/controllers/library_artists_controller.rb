class LibraryArtistsController < ApplicationController
  
  def index
    @library_artists = Library::Artist.order(:name).limit(10, 1).all
  end

  def show
    if params[:commit]
      name = params[:what_request].delete(:name)
      make_what_request 
    else
      name = params[:name]
    end
    @library_artist = Library::Artist.first! name: name
    @library_artist_albums = @library_artist.albums
  end
end
