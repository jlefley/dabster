module Dabster
  module PlaybackHelper

    def previous_disabled?
      @status == :empty || @current_position == 0
    end

    def play_disabled?
      @status == :empty || @status == :playing
    end

    def next_disabled?
      @status == :empty 
    end

    def pause_disabled?
      @status == :empty || @status == :paused
    end

  end
end
