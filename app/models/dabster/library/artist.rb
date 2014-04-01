module Dabster
  module Library
    class Artist < Sequel::Model
      set_dataset db[:libdb__albums].group(:albumartist).select{ Sequel.as(:albumartist, :name) }.
        select_more{ Sequel.as(:albumartist_sort, :sort_name) }.select_more { Sequel.as(:mb_albumartistid, :mb_artistid) }
      
      set_primary_key :name

      one_to_many :albums, class: 'Dabster::Album', key: :albumartist
    end
  end
end
