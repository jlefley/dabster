class GroupsController < ApplicationController

  def update
    @group = Group.first!(id: params[:id])
    @group.update_fields(group_params, [:whatcd_confidence])
    flash[:notice] = 'Group updated successfully'
    redirect_to @group.library_album
  rescue Sequel::ValidationFailed => e
    flash.now[:error] = e.message
    render :edit
  end

  def edit
    @group = Group.first!(id: params[:id])
  end

  def associate_whatcd
    library_album = Library::Album.first!(id: group_params.fetch(:library_album_id).to_i)
    torrent_group = Whatcd::TorrentGroup.find(id: group_params.fetch(:whatcd_id).to_i)
    Sequel::Model.db.transaction do
      @group = GroupService.new(Group).associate_group(torrent_group, library_album, 1.0)
      ArtistService.new(Artist).associate_artists(@group)
    end
    flash[:notice] = 'Association successful'
    redirect_to @group.library_album
  rescue StandardError => e
    raise DabsterApp::Error, "#{e.class} (#{e.message})", e.backtrace
  end

  private

  def group_params
    @group_params ||= params.require(:group).permit!
  end

end
