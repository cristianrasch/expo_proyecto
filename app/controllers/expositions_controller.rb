class ExpositionsController < ApplicationController
  PUBLIC_ACTIONS = [:index, :show]
  
  skip_before_filter :authenticate_user!, :only => PUBLIC_ACTIONS
  before_filter :ensure_admin_logged_in!, :except => PUBLIC_ACTIONS

  def index
    @expositions = Exposition.sorted.page(params[:page])
  end
  
  def new
    @exposition = Exposition.new
  end
  
  def create
    @exposition = Exposition.new(params[:exposition].merge(:year => params[:date][:year]))
    
    if @exposition.save
      redirect_to exposition_path(@exposition.year), 
                  :notice => "#{Exposition.model_name.human.humanize} guardada"
    else
      render :new
    end
  end
  
  def show
    @exposition = Exposition.find_by_year(params[:id])
    @projects = @exposition.projects.with_images
  end
  
  def edit
    @exposition = Exposition.find_by_year(params[:id])
  end
  
  def update
    @exposition = Exposition.find(params[:id])
    
    if @exposition.update_attributes(params[:exposition].merge(:year => params[:date][:year]))
      redirect_to exposition_path(@exposition.year), 
                  :notice => "#{Exposition.model_name.human.humanize} guardada"
    else
      render :edit
    end
  end
  
  def destroy
    Exposition.destroy params[:id]
    redirect_to expositions_path, :notice => "#{Exposition.model_name.human.humanize} eliminada"
  end
end
