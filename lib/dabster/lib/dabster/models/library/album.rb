module Library
  class Album < Sequel::Model(:libdb__albums)
    one_to_one :group, class: 'Group', key: :library_album_id
    one_to_many :library_items, class: 'Library::Item', key: :album_id

    def ordered_library_items
      library_items_dataset.order(:track).all
    end

    def album_only_letters
      album.gsub(/\W+/, ' ')
    end

    def albumartist_only_letters
      albumartist.gsub(/\W+/, ' ')
    end

    def whatcd_confidence
      group.whatcd_confidence if group
    end

    dataset_module do
      def unmatched
        eager_graph(:group).where(group__id: nil)
      end

      def matched
        eager_graph(:group).exclude(group__id: nil)
      end
    end

  end
end
