class GroupsController < ApplicationController

  def create
    #execute 
    association_params
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
    Sequel::Model.db.transaction do
      @group = GroupService.new(Group, Library::Album).associate_group(association_params)
      ArtistService.new(Artist).associate_artists(@group)
    end
  rescue StandardError => e
    raise Dabster::Error, "#{e.class} (#{e.message})", e.backtrace
  end

  def association_params
    results = JSON.parse(params[:group].delete(:what_results), symbolize_names: true)
    what_id = params[:group].delete(:what_id)
    api_response = WhatAPIConnection.new.make_request(action: 'torrentgroup', id: what_id)
    result_group = results.select { |g| g[:groupId] == what_id.to_i }.first
    raise Dabster::Error unless result_group[:groupId] == api_response[:group][:id]
    raise Dabster::Error unless result_group[:groupName] == api_response[:group][:name]
    raise Dabster::Error unless result_group[:groupYear] == api_response[:group][:year]
    merged_group = api_response[:group].merge(result_group)
    
    puts merged_group[:id].inspect
    puts merged_group[:name].inspect
    puts merged_group[:artist].inspect
    puts merged_group[:tags].inspect
    puts merged_group[:year].inspect
    puts merged_group[:releaseType].inspect
    puts merged_group[:musicInfo].inspect
    puts merged_group[:recordLabel].inspect
    puts merged_group[:catalogueNumber].inspect
    
    #params[:group].merge(result_groups: results.map { |g| WhatGroup.new g }, result_group_id: what_id, what_confidence: 1.0)
  end

end
