module Library
  class Album < Sequel::Model(:libdb__albums)
    one_to_one :group, class: 'Group', key: :library_album_id
    one_to_many :library_items, class: 'Library::Item', key: :album_id
  end
end
