class LibraryArtistsController < ApplicationController
  def index
    @library_artists = Library::Artist.order(:name).limit(10, 1).all
  end
end
