require 'json'

class Group < Sequel::Model
  include ArtistMatching
  plugin :categorized_relationship

  WHAT_RELEASE_TYPES = %w(Album Soundtrack EP Anthology Compilation DJ\ Mix Single Live\ album Remix Bootleg Interview Mixtape Unknown Concert\ Recording Demo)

  serialize_attributes :json, :what_artists, :what_tags
  many_to_one :library_album, class: 'Library::Album', key: :library_album_id
  many_to_one :what_artist, class: 'Artist', key: :what_artist_id
  categorized_relationship :artists, :type, class: 'Artist', relationship_class: 'ArtistGroupRelationship'

  def validate 
    super

    validates_presence :library_album_id

    if what_id
      validates_presence :what_artist_name
      validates_presence :what_name
      validates_presence :what_tags
      validates_presence :what_year
      validates_presence :what_release_type
      validates_presence :what_artists
      validates_presence :what_confidence
      validates_type Hash, :what_artists
      validates_type Array, :what_tags
      validates_includes WHAT_RELEASE_TYPES, :what_release_type
    end

    validates_presence :what_artist_type if what_artist_id
    validates_presence :what_artist_id if what_artist_type
      
  end

  def library_items
    library_album.library_items
  end

  def update_what_artist_association
    artists.each do |type, artists|
      if matching = artists.select { |a| a.what_name == what_artist_name }.first
        update(what_artist_type: type.to_s, what_artist_id: matching.id)
        return
      end
    end
    raise(RuntimeError, 'what artist name not contained in artists')
  end

  def what_artist_type
    super ? super.to_sym : super
  end

end
