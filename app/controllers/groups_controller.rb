class GroupsController < ApplicationController

  def create
    execute 
    flash[:notice] = 'Group created successfully'
    redirect_to @group.library_album
  rescue StandardError => e
    raise DabsterApp::Error, "#{e.class} (#{e.message})", e.backtrace
  end

  def update
    case params.fetch(:commit)
    when 'Update'
      @group = Group.first!(id: params[:id])
      @group.update_fields(group_params, [:what_confidence])
      flash[:notice] = 'Group updated successfully'
      redirect_to @group
    else
      execute 
      flash[:notice] = 'Group updated successfully'
      redirect_to @group.library_album
    end
  rescue StandardError => e
    raise DabsterApp::Error, "#{e.class} (#{e.message})", e.backtrace
  end

  def index
    @query_options = OpenStruct.new(params[:query_options])
    ds = Group.dataset
    case @query_options.sort
    when 'confidence'
      ds = ds.order(:what_confidence)
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

  private

  def group_params
    @group_params ||= params.require(:group).permit!
  end

  def execute
    results = JSON.parse(group_params.fetch(:results), symbolize_names: true)
    selected_group = results.select { |g| g[:groupId] == group_params.fetch(:what_id).to_i }.first
    result_group = WhatScraper.new(WhatAPIConnection.new, WhatGroup, WhatAPICache).scrape_group(selected_group)
    library_album = Library::Album.first!(id: group_params.fetch(:library_album_id).to_i)
    Sequel::Model.db.transaction do
      @group = GroupService.new(Group).associate_group(result_group, library_album, 1.0)
      ArtistService.new(Artist).associate_artists(@group)
    end
  end

end
