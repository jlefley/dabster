class PlaybackController < ApplicationController
  def show
    @status = $playback_proxy.status

    if @playlist = $playback_proxy.current_playlist
      @items = @playlist.items
      @current_position = @playlist.current_position
    end
  end

  def pause
    $playback_proxy.pause_playback
    render json: true
  end

  def play
    $playback_proxy.start_playback
    render json: true
  end

  def next
    $playback_proxy.play_next_entry
    render json: true
  end

  def previous
    $playback_proxy.play_previous_entry
    render json: true
  end
end
