class DummyXmmsClient

  def initialize
    @entry_ids = []
    @playback_status = :stopped
    @current_position = 0
  end

  def clear_playlist
    @current_position = 0
    @entry_ids = []
  end

  def add_entry(entry)
    @entry_ids << @entry_ids.length
  end

  def entry_ids
    @entry_ids.dup
  end

  def stop_playback
    prev = @playback_status
    @playback_status = :stopped
    @playback_status_changed_listener.call(@playback_status) if prev != @playback_status
  end

  def start_playback
    prev = @playback_status
    @playback_status = :playing
    @playback_status_changed_listener.call(@playback_status) if prev != @playback_status
    @playback_started_listener.call(@entry_ids[@current_position]) if prev == :stopped
  end

  def pause_playback
    prev = @playback_status
    @playback_status = :paused
    @playback_status_changed_listener.call(@playback_status) if prev != @playback_status
  end

  def playback_status
    @playback_status
  end

  def current_position
    @current_position
  end

  def play_next_entry
    @current_position += 1
    @current_position_changed_listener.call(@current_position)
    @playback_started_listener.call(@entry_ids[@current_position])
  end
  
  def play_previous_entry
    @current_position -= 1
    @current_position_changed_listener.call(@current_position)
    @playback_started_listener.call(@entry_ids[@current_position])
  end

  def on_current_position_changed(&listener)
    @current_position_changed_listener = listener
  end

  def on_playback_started(&listener)
    @playback_started_listener = listener
  end

  def on_playback_status_changed(&listener)
    @playback_status_changed_listener = listener
  end

end
