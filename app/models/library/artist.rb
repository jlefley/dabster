module Library
  class Artist < Sequel::Model
    set_dataset Album.group(:albumartist).select{ Sequel.as(:albumartist, :name) }
    set_primary_key :name

    one_to_many :albums, key: :albumartist
  end
end
