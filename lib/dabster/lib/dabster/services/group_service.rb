class GroupService

  attr_reader :group_class

  WHAT_GROUP_MAPPING = {
      id:               :what_id,
      name:             :what_name,
      tags:             :what_tags,
      year:             :what_year,
      release_type:     :what_release_type_id,
      artists:          :what_artists,
      record_label:     :what_record_label,
      catalog_number:   :what_catalog_number
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
    group.what_confidence = confidence
    group.what_updated_at = Time.now

    group.save

    group
  end

  private

  def group_fields
    WHAT_GROUP_MAPPING.map { |k,v| v }
  end

end
