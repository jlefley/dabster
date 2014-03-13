class GroupsController < ApplicationController

  def create
    execute 
    flash[:notice] = 'Library album - group associated created'
    redirect_to request.referrer
  end

  def update
    execute 
    flash[:notice] = 'Library album - group association updated'
    redirect_to request.referrer
  end

  private

  def execute
    #Sequel::Model.db.transaction do
    #  @group = GroupService.new(Group, Library::Album).associate_group(association_params)
    #  ArtistService.new(Artist).associate_artists(@group)
    #end
  rescue StandardError => e
    raise Dabster::Error, "#{e.class} (#{e.message})", e.backtrace
  end

  def association_params
    results = JSON.parse(params[:group].delete(:what_results), symbolize_names: true)
    what_id = params[:group].delete(:what_id)
    api_response = WhatAPIConnection.new.make_request(action: 'torrentgroup', id: what_id)
    result_group = results.select { |g| g[:groupId] == what_id.to_i }.first
    #params[:group].merge(result_groups: results.map { |g| WhatGroup.new g }, result_group_id: what_id, what_confidence: 1.0)
  end

end
