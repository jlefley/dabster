class GroupsController < ApplicationController

  def create
    GroupService.new(Group, Library::Album).associate_group(association_params)
    flash[:notice] = 'Library album associated with group'
    redirect_to request.referrer
  end

  def update
    GroupService.new(Group, Library::Album).associate_group(association_params)
    flash[:notice] = 'Library album association updated'
    redirect_to request.referrer
  end

  private

  def association_params
    results = JSON.parse(params[:group].delete(:what_results), symbolize_names: true)
    what_id = params[:group].delete(:what_id)
    params[:group].merge(result_groups: results.map { |g| WhatGroup.new g }, result_group_id: what_id, what_confidence: 1.0)
  end

end
