class GroupsController < ApplicationController

  def create
    execute 
    flash[:notice] = 'Group created successfully'
    redirect_to @group.library_album
  end

  def update
    execute 
    flash[:notice] = 'Group updated successfully'
    redirect_to @group.library_album
  end

  private

  def execute
    results = JSON.parse(params[:group].fetch(:results), symbolize_names: true)
    selected_group = results.select { |g| g[:groupId] == params[:group].fetch(:what_id).to_i }.first
    result_group = WhatScraper.new(WhatAPIConnection.new, WhatGroup, WhatAPICache).scrape_group(selected_group)
    library_album = Library::Album.first!(id: params[:group].fetch(:library_album_id).to_i)
    Sequel::Model.db.transaction do
      @group = GroupService.new(Group).associate_group(result_group, library_album, 1.0)
      ArtistService.new(Artist).associate_artists(@group)
    end
  rescue StandardError => e
    raise DabsterApp::Error, "#{e.class} (#{e.message})", e.backtrace
  end

end
