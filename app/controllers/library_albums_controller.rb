class LibraryAlbumsController < ApplicationController
  def show
    make_what_request if params[:commit]
    @library_album = Library::Album.first! id: params[:id]
    @library_items = @library_album.ordered_library_items
    @group = @library_album.group || Group.new
  end

  private

  def make_what_request
    @what_response = WhatScraper.new(WhatAPIConnection.new, WhatGroup).scrape_results(params[:what_request])
    @what_request = OpenStruct.new(params[:what_request])
  end
end
