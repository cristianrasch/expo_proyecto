class ActivitiesController < ApplicationController
  before_filter :ensure_admin_logged_in!
  before_filter :fetch_activity, :only => [:show, :edit, :update]

  # cache_sweeper :activity_sweeper, :only => [:create, :update, :destroy]

  def index
    @exposition = Exposition.find_by_year(params[:exposition_id])
    @activities = @exposition.activities
  end

  def new
    @exposition = Exposition.find_by_year(params[:exposition_id])
    @activity = @exposition.activities.build
  end

  def create
    @exposition = Exposition.find(params[:exposition_id])
    @activity = @exposition.activities.build(params[:activity])

    if @activity.save
      redirect_to(exposition_activities_path(@exposition.year),
                  :notice => "#{Activity.model_name.human.humanize} guardada")
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @activity.update_attributes(params[:activity])
      redirect_to(exposition_activities_path(@activity.exposition.year),
                  :notice => "#{Activity.model_name.human.humanize} guardada")
    else
      render :edit
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    redirect_to exposition_activities_path(@activity.exposition.year),
                :notice => "#{Activity.model_name.human.humanize} eliminada"
  end

  private

  def fetch_activity
    @activity = Activity.find(params[:id])
  end
end
