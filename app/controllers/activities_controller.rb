class ActivitiesController < ApplicationController
  before_filter :ensure_admin_logged_in!

  def index
    @exposition = Exposition.find_by_year(params[:exposition_id])
    @activities = @exposition.activities.order('date').page(params[:page])
  end

  def new
    @exposition = Exposition.find_by_year(params[:exposition_id])
    @activity = @exposition.activities.build
  end
  
  def create
    @exposition = Exposition.find(params[:exposition_id])
    @activity = @exposition.activities.build(params[:activity])
    
    if @activity.save
      redirect_to(exposition_activities_path(@exposition.year), :notice => "#{Activity.model_name.human.humanize} guardada")
    else
      render :new
    end
  end
  
  def show
    @activity = Activity.find(params[:id])
  end
  
  def edit
    @activity = Activity.find(params[:id])
  end
  
  def update
    @activity = Activity.find(params[:id])
    
    if @activity.update_attributes(params[:activity])
      redirect_to(exposition_activities_path(@activity.exposition.year), :notice => "#{Activity.model_name.human.humanize} guardada")
    else
      render :edit
    end
  end
  
  def destroy
    @activity = Activity.find(params[:id], :include => :exposition)
    @activity.delete
    redirect_to(exposition_activities_path(@activity.exposition.year), 
                :notice => "#{Activity.model_name.human.humanize} eliminada")
  end
end
