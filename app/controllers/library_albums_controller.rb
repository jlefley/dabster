class LibraryAlbumsController < ApplicationController
  def show
    make_what_request if params[:commit]
    @library_album = Library::Album.first! id: params[:id]
    @release_group = @library_album.release_group || ReleaseGroup.new
  end
end
