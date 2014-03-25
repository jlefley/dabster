class GroupsController < ApplicationController

  def update
    @group = Group.first!(id: params[:id])
    @group.update_fields(group_params, [:what_confidence])
    flash[:notice] = 'Group updated successfully'
    redirect_to @group
  rescue Sequel::ValidationFailed => e
    flash.now[:error] = e.message
    render :edit
  end

  def index
    @query_options = OpenStruct.new(params[:query_options])
    ds = Group.dataset
    case @query_options.sort
    when 'confidence'
      ds = ds.order(:what_confidence)
    when 'whatcd updated at'
      ds = ds.order(:what_updated_at)
    else
      ds = ds.order(:what_name)
    end

    case @query_options.order
    when 'descending'
      ds = ds.reverse
    end
    @groups = ds.paginate(page, 50)
  end

  def show
    @group = Group.first!(id: params[:id])
    @library_album = @group.library_album
  end

  def edit
    @group = Group.first!(id: params[:id])
  end

  def associate_what_cd
    library_album = Library::Album.first!(id: group_params.fetch(:library_album_id).to_i)
    torrent_group = WhatCD::TorrentGroup.find(id: group_params.fetch(:what_id).to_i)
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
