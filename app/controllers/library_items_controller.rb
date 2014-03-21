class LibraryItemsController < ApplicationController

  def show
    @library_item = Library::Item.first!(id: params[:id])
    @library_album = @library_item.library_album
    @group = @library_album.group
  end

end
