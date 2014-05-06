module TestSupport
  module PlaylistHelper

    def play_playlist(plist)
      visit dabster.playlist_path(plist)
      click_button('Play')
      expect(page).to show_now_playing plist.items[0].library_item
      expect(page).to show_current_position 0
    end

  end
end
