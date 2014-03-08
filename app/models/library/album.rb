module Library
  class Album < Sequel::Model(:libdb__albums)
    one_to_one :release_group, class: ReleaseGroup, key: :library_album_id
  end
end
