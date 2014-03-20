class LibraryAlbumsController < ApplicationController
  def show
    @library_album = Library::Album.first! id: params[:id]
    make_what_request if params[:commit]
    @library_items = @library_album.ordered_library_items
    @group = @library_album.group || Group.new
  end

  def index
    @library_albums = Library::Album.order(:album).limit(40, 0).all
  end

  private

  def make_what_request
    @what_response = WhatScraper.new(WhatAPIConnection.new, WhatGroup, WhatAPICache).scrape_results(params[:what_request])
    @what_request = OpenStruct.new(params[:what_request])
    @sorted_groups = @what_response.sort_groups(artist: @library_album.albumartist, name: @library_album.album)
  end
end
