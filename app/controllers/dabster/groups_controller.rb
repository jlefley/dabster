module Dabster
  class GroupsController < ApplicationController

    def update
      @group = Dabster::Group.first!(id: params[:id])
      @group.update_fields(group_params, [:whatcd_confidence])
      flash[:notice] = 'Group updated successfully'
      redirect_to @group.library_album
    rescue Sequel::ValidationFailed => e
      flash.now[:error] = e.message
      render :edit
    end

    def edit
      @group = Dabster::Group.first!(id: params[:id])
      @group_artists = @group.artists_by(:type)
    end

    def show
      @group = Dabster::Group.first!(id: params[:id])
      @group_artists = @group.artists_by(:type)
    end

    def destroy
      @group = Dabster::Group.first!(id: params[:id])
      @group.destroy
      redirect_to groups_path, notice: 'Group deleted'
    end

    def associate_whatcd
      library_album = Dabster::Library::Album.first!(id: group_params.fetch(:library_album_id).to_i)
      torrent_group = Dabster::Whatcd::TorrentGroup.find(id: group_params.fetch(:whatcd_id).to_i)
      Sequel::Model.db.transaction do
        @group = Dabster::Service::GroupService.new(Group).associate_group(torrent_group, library_album, 1.0)
        Dabster::Service::ArtistService.new(Artist).associate_artists(@group)
      end
      flash[:notice] = 'Association successful'
      redirect_to @group.library_album
    rescue StandardError => e
      raise Dabster::Error, "#{e.class} (#{e.message})", e.backtrace
    end

    def index
      @query_options = OpenStruct.new(params[:query_options])
      ds = Dabster::Group
      case @query_options.sort
      when 'what.cd confidence'
        ds = ds.order(:whatcd_confidence)
      when 'what.cd updated at'
        ds = ds.order(:whatcd_updated_at)
      when 'updated at'
        ds = ds.order(:updated_at)
      else
        ds = ds.order(:whatcd_name)
      end

      case @query_options.filter
      when 'non-existing libray album'
        ds = ds.no_library_album
      when 'what.cd ID not unique'
        ds = ds.whatcd_id_not_unique
      end
      
      case @query_options.order
      when 'descending'
        ds = ds.reverse
      end
      @groups = ds.paginate(page, 50)
    end

    private

    def group_params
      @group_params ||= params.require(:group).permit!
    end

  end
end
