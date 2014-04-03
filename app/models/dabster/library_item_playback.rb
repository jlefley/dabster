module Dabster
  class LibraryItemPlayback < Sequel::Model
    plugin :timestamps, create: :playback_started_at
  end
end
