require 'json'
require 'dabster/models/artist_group_relationship'

class Group < Sequel::Model
  include ArtistMatching
  plugin :categorized_relationship

  serialize_attributes :json, :what_artists, :what_tags
  many_to_one :library_album, class: 'Library::Album', key: :library_album_id
  categorized_relationship :artists, class: 'Artist', relationship_class: 'ArtistGroupRelationship'

  def validate 
    super

    validates_presence :library_album_id
    validates_unique :what_id
    
    if what_id
      validates_presence :what_name
      validates_presence :what_tags
      validates_presence :what_year
      validates_presence :what_release_type_id
      validates_presence :what_artists
      validates_presence :what_confidence
      validates_numeric :what_confidence
      validates_presence :what_updated_at
      validates_type Hash, :what_artists
      validates_type Array, :what_tags
      if what_confidence && (what_confidence.to_f < 0 || what_confidence.to_f > 1)
        errors.add(:what_confidence, 'must be between 0 and 1, inclusive')
      end
    end

  end

  def library_album_name
    library_album.album
  end

  def library_items
    library_album.library_items
  end

  def what_release_type
    type = db[self.class.table_name].join(:whatcd_release_types, id: what_release_type_id).select(:name).first
    return type[:name] if type
    'missing'
  end

  def add_group_artists_to_items
=begin
    what_artists.each do |type, artists|
      artists.each do |artist|
        if what_artist.include?(artist[:name])
          library_items.each do |item|
            item.add_artist(Artist.first!(what_id: artist[:id]), type: type, group_artist: true, confidence: 0.99)
          end
        end
      end
    end
=end
  end

  def remove_group_artists_from_items
    library_items.each do |item|
      item.remove_all_artists(group_artist: true)
    end
  end

end
