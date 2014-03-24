class LibraryAlbumsController < ApplicationController
  def show
    @library_album = Library::Album.first! id: params[:id]
    make_what_request if params[:commit]
    @library_items = @library_album.ordered_library_items
    @group = @library_album.group || Group.new
  end

  def index
    @query_options = OpenStruct.new(params[:query_options])
    ds = Library::Album.dataset
    case @query_options.matched_status
    when 'matched'
      ds = ds.matched
    when 'unmatched'
      ds = ds.unmatched
    end
    @library_albums = ds.paginate(page, 50).order(:album)
  end

  private

  def make_what_request
    @what_response = WhatCD::TorrentGroup.search(params[:what_request])
    @what_request = OpenStruct.new(params[:what_request])
    @sorted_groups = @what_response.sort_groups(artist: @library_album.albumartist, name: @library_album.album)
  end

end
