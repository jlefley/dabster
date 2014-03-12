class GroupService

  attr_reader :group_class, :library_album_class

  WHAT_GROUP_MAPPING = {
      groupId: :what_id,
      artist: :what_artist,
      groupName: :what_name,
      tags: :what_tags,
      groupYear: :what_year,
      releaseType: :what_release_type
    }

  def initialize group, library_album
    @group_class = group
    @library_album_class = library_album
  end

  def associate_group parameters
    parameters.delete_if { |k, v| v.nil? }

    result_groups = parameters.fetch(:result_dgroups)
    library_album_id = parameters.fetch(:library_album_id).to_i
    result_group_id = parameters.fetch(:result_group_id).to_i

    result_group = result_groups.select { |g| g.id == result_group_id }.first
    raise ArgumentError, 'result group matching result_group_id not found' unless result_group
    
    library_album = library_album_class.first!(id: library_album_id)
  
    if (group = library_album.group).nil?
      group = group_class.new
      group.library_album = library_album
    end
   
    group.set_fields(result_group.map(WHAT_GROUP_MAPPING), group_fields)
    group.set_fields(parameters, [:what_confidence])
    group.what_artists = result_group.artists_hashes

    group.save

    group
  end

  private

  def group_fields
    WHAT_GROUP_MAPPING.map { |k,v| v }
  end

end
