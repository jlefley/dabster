module Dabster
  class LibraryAlbumsController < ApplicationController
    def show
      @library_album = Library::Album.first! id: params[:id]
      make_whatcd_request if params[:commit]
      @library_items = @library_album.ordered_library_items
      if @group = @library_album.group
        @group_artists = @group.artists_by(:type)
      else
        @group = Group.new
      end
    end

    def index
      @query_options = OpenStruct.new(params[:query_options])
      ds = Library::Album.dataset

      case @query_options.filter
      when 'matched'
        ds = ds.matched
      when 'unmatched'
        ds = ds.unmatched
      when 'not digital'
        ds = ds.exclude(media: ['CD', 'Digital Media', '', 'SACD', 'CD-R', 'HDCD', 'Hybrid SACD'])
      else
        @query_options.filter = 'all'
      end

      @library_albums = ds.order(:album).paginate(page, 50)
    end

    private

    def make_whatcd_request
      @whatcd_response = Whatcd::TorrentGroup.search(params[:whatcd_request])
      @whatcd_request = OpenStruct.new(params[:whatcd_request])
      @sorted_groups = @whatcd_response.sort_groups(artist: @library_album.albumartist, name: @library_album.album)
    end

  end
end
