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
    ds = Library::Album

    case @query_options.filter
    when 'matched'
      ds = ds.matched
    when 'unmatched'
      ds = ds.unmatched
      @query_options.sort = 'album'
    when 'not digital'
      ds = ds.exclude(media: ['CD', 'Digital Media', '', 'SACD', 'CD-R', 'HDCD', 'Hybrid SACD'])
      @query_options.sort = 'album'
    else
      @query_options.sort = 'album'
      @query_options.filter = 'all'
    end

    case @query_options.sort
    when 'what.cd confidence'
      ds = ds.order(:whatcd_confidence)
    when 'what.cd updated at'
      ds = ds.order(:whatcd_updated_at)
    else
      @query_options.sort = 'album' 
      ds = ds.order(:album)
    end

    case @query_options.order
    when 'descending'
      ds = ds.reverse
    else
      @query_options.order = 'ascending'
    end

    @library_albums = ds.paginate(page, 50)
  end

  private

  def make_whatcd_request
    @whatcd_response = Whatcd::TorrentGroup.search(params[:whatcd_request])
    @whatcd_request = OpenStruct.new(params[:whatcd_request])
    @sorted_groups = @whatcd_response.sort_groups(artist: @library_album.albumartist, name: @library_album.album)
  end

end
