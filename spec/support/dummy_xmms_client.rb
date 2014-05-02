class DummyXmmsClient

  def initialize
    clear_playlist
  end

  def clear_playlist
    @entry_ids = []
  end

  def add_entry(entry)
    @entry_ids << @entry_ids.length
  end

  def entry_ids
    @entry_ids.dup
  end

  def stop_playback
    @playback_status = :stopped
  end

  def start_playback
    @playback_status = :playing
  end

  def playback_status
    @playback_status
  end

  def on_current_position_changed(&listener)
    @current_position_changed_listener = listener
  end

  def on_playback_started(&listener)
    @playback_started_listener = listener
  end

  def change_current_position(new_position)
    @current_position_changed_listener.call(new_position)
    @playback_started_listener.call(@entry_ids[new_position])
  end

end
