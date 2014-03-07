class LibraryAlbumsController < ApplicationController
  def show
    make_what_request if params[:commit]
    @library_album = Library::Album.first! id: params[:id]
  end
end
