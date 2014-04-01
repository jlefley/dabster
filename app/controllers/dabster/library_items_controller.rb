module Dabster
  class LibraryItemsController < ApplicationController

    def show
      @library_item = Dabster::Library::Item.first!(id: params[:id])
      @library_album = @library_item.library_album
      @group = @library_album.group
    end

  end
end
