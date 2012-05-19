class ProjectsController < ApplicationController
  PUBLIC_ACTIONS = [:index, :gallery, :show, :prev, :next]
  
  skip_before_filter :authenticate_user!, :only => PUBLIC_ACTIONS
  before_filter :fetch_exposition, :only => [:index, :gallery, :new]
  
  def index
    respond_to do |format|
      format.html do
        @project = Project.new(params[:project])
        @projects = @exposition.filter_projects(@project)
      end
      format.pdf do
        send_data @exposition.print_projects_pdfs, :filename => 'proyectos.pdf', :type => 'application/pdf'
      end
    end
  end
  
  def gallery
    @projects = @exposition.projects.page(params[:page]).per(12)
  end

  def new
    @project = @exposition.projects.build
  end
  
  def create
    @exposition = Exposition.find(params[:exposition_id])
    @project = @exposition.projects.build(params[:project])
    @project.user_id = current_user.id
    
    if @project.save
      redirect_to exposition_projects_path(@exposition.year), 
                  :notice => "#{Project.model_name.human.humanize} guardado"
    else
      render :new
    end
  end
  
  def show
    @project = Project.find(params[:id], :include => [:exposition, :authors])
  
    respond_to do |format|
      format.html
      format.pdf do
        send_data @project.to_pdf, :filename => @project.filename, :type => 'application/pdf'
      end
    end
  end
  
  def edit
    @project = Project.find(params[:id], :include => [:exposition, :authors])
    return unless owner_or_admin_logged_in?
  end
  
  def update
    @project = Project.find(params[:id])
    return unless owner_or_admin_logged_in?
    
    if @project.update_attributes(params[:project])
      redirect_to exposition_projects_path(@project.exposition.year), 
                  :notice => "#{Project.model_name.human.humanize} guardado"
    else
      render :edit
    end
  end
  
  def destroy
    @project = Project.find(params[:id], :include => :exposition)
    return unless owner_or_admin_logged_in?
    
    @project.destroy
    redirect_to exposition_projects_path(@project.exposition.year), 
                :notice => "#{Project.model_name.human.humanize} eliminado"
  end
  
  def prev
    @project = Project.find_prev(params[:id], params[:exposition_id])
    render :show
  end
  
  def next
    @project = Project.find_next(params[:id], params[:exposition_id])
    render :show
  end
  
  private
  
  def fetch_exposition
    @exposition = Exposition.find_by_year(params[:exposition_id])
  end
  
  def owner_or_admin_logged_in?
    if @project.editable_by? current_user
      true
    else
      redirect_to exposition_projects_path(@project.exposition.year), :alert => "Acceso denegado!"
    end
  end
end
