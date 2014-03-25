require 'json'
require 'dabster/models/artist_group_relationship'

class Group < Sequel::Model
  include ArtistMatching
  plugin :categorized_relationship

  serialize_attributes :json, :whatcd_artists, :whatcd_tags
  many_to_one :library_album, class: 'Library::Album', key: :library_album_id
  categorized_relationship :artists, class: 'Artist', relationship_class: 'ArtistGroupRelationship'

  def validate 
    super

    validates_presence :library_album_id
    validates_unique :whatcd_id
    
    if whatcd_id
      validates_presence :whatcd_name
      validates_presence :whatcd_tags
      validates_presence :whatcd_year
      validates_presence :whatcd_release_type_id
      validates_presence :whatcd_artists
      validates_presence :whatcd_confidence
      validates_numeric :whatcd_confidence
      validates_presence :whatcd_updated_at
      validates_type Hash, :whatcd_artists
      validates_type Array, :whatcd_tags
      if whatcd_confidence && (whatcd_confidence.to_f < 0 || whatcd_confidence.to_f > 1)
        errors.add(:whatcd_confidence, 'must be between 0 and 1, inclusive')
      end
    end

  end

  def library_album_name
    library_album.album
  end

  def library_items
    library_album.library_items
  end

  def whatcd_release_type
    type = db[self.class.table_name].join(:whatcd_release_types, id: whatcd_release_type_id).select(:name).first
    return type[:name] if type
    'missing'
  end

  def add_group_artists_to_items
=begin
    whatcd_artists.each do |type, artists|
      artists.each do |artist|
        if whatcd_artist.include?(artist[:name])
          library_items.each do |item|
            item.add_artist(Artist.first!(whatcd_id: artist[:id]), type: type, group_artist: true, confidence: 0.99)
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
