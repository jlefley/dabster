module TestSupport
  module Factory

    attr_reader :item0, :item1, :item2, :item3

    def create_static_playlist
      playlist = Dabster::Playlist.create
      @item0 = Dabster::Library::Item.create title: 'title0', artist: 'artist0', path: 'path0'
      @item1 = Dabster::Library::Item.create title: 'title1', artist: 'artist1', path: 'path1'
      @item2 = Dabster::Library::Item.create title: 'title2', artist: 'artist2', path: 'path2'
      playlist.add_item(library_item: @item0, position: 0)
      playlist.add_item(library_item: @item1, position: 1)
      playlist.add_item(library_item: @item2, position: 2)
      playlist.update(current_position: 0)
      playlist 
    end

  end
end
