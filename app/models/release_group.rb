class ReleaseGroup < Sequel::Model
  serialize_attributes :json, :artists, :tags
  many_to_one :library_album, class: Library::Album, key: :library_album_id
end
