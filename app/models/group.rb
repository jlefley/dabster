class Group < Sequel::Model
  serialize_attributes :json, :what_artists, :what_tags
  many_to_one :library_album, class: 'Library::Album', key: :library_album_id
  many_to_many :artists

  def validate
    super

    validates_presence :library_album_id

    if what_id
      validates_presence :what_artist
      validates_presence :what_name
      validates_presence :what_tags
      validates_presence :what_year
      validates_presence :what_release_type
      validates_presence :what_artists
      validates_presence :what_confidence
      validates_type Array, :what_artists
      validates_type Array, :what_tags
    end

  end

  def library_items
    library_album.library_items
  end

end
