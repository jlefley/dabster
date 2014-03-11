class Group < Sequel::Model
  default_set_fields_options[:missing] = :raise
  serialize_attributes :json, :what_artists, :what_tags
  many_to_one :library_album, class: Library::Album, key: :library_album_id
end
