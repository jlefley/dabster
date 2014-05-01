class DummyXmmsClient

  def initialize
    clear_playlist
  end

  def clear_playlist
    @entries = []
  end

  def add_entry(entry)
    @entries << @entries.length
  end

  def entries
    @entries.dup
  end

  def on_current_position_changed(&listener)
    @current_position_changed_listener = listener
  end

  def change_current_position(new_position)
    @current_position_changed_listener.call(new_position)
  end

end
