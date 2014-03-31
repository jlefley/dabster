module Dabster
  module Services
    class GroupService

      attr_reader :group_class

      WHAT_GROUP_MAPPING = {
          id:               :whatcd_id,
          name:             :whatcd_name,
          tags:             :whatcd_tags,
          year:             :whatcd_year,
          release_type:     :whatcd_release_type_id,
          artists:          :whatcd_artists,
          record_label:     :whatcd_record_label,
          catalog_number:   :whatcd_catalog_number
        }

      def initialize group
        @group_class = group
      end

      def associate_group result_group, library_album, confidence
        raise(ArgumentError, 'argument cannot be nil') unless result_group && library_album && confidence
        
        if (group = library_album.group).nil?
          group = group_class.new
          group.library_album = library_album
        end
       
        group.set_fields(result_group.map(WHAT_GROUP_MAPPING), group_fields)
        group.whatcd_confidence = confidence
        group.whatcd_updated_at = Time.now

        group.save

        group
      end

      private

      def group_fields
        WHAT_GROUP_MAPPING.map { |k,v| v }
      end

    end
  end
end
