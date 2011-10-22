class ProjectsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show, :next, :prev]
  before_filter :only => :index do |controller|
    authenticate_user_if_this_years_exposition params[:exposition_id].to_i
  end
  before_filter :only => :show do |controller|
    @project = Project.find(params[:id], :include => [:exposition, :authors])
    authenticate_user_if_this_years_exposition @project.exposition.year
  end
  before_filter :only => [:prev, :next] do |controller|
    @project = Project.send("find_#{controller.action_name}", params[:id], params[:exposition_id])
    authenticate_user_if_this_years_exposition @project.exposition.year
  end
  
  before_filter :fetch_exposition, :only => [:index, :new]
  
  def index
    respond_to do |format|
      format.html { @projects = @exposition.projects.order("created_at desc").page(params[:page]).per(12) }
      format.pdf do 
        send_file(@exposition.print_projects_pdfs, :type => 'application/pdf')
      end
    end
  end

  def new
    @project = @exposition.projects.build
  end
  
  def create
    @exposition = Exposition.find(params[:exposition_id])
    @project = @exposition.projects.build(params[:project])
    @project.user_id = current_user.id
    
    if @project.save
      redirect_to exposition_projects_path(@exposition.year), :notice => "#{Project.model_name.human.humanize} guardado"
    else
      render :new
    end
  end
  
  def show
    @project = Project.find(params[:id], :include => [:exposition, :authors])
  
    respond_to do |format|
      format.html
      format.pdf { send_file @project.to_pdf, :type => 'application/pdf' }
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
      redirect_to exposition_projects_path(@project.exposition.year), :notice => "#{Project.model_name.human.humanize} guardado"
    else
      render :edit
    end
  end
  
  def destroy
    @project = Project.find(params[:id], :include => :exposition)
    return unless owner_or_admin_logged_in?
    @project.destroy
    redirect_to exposition_projects_path(@project.exposition.year), :notice => "#{Project.model_name.human.humanize} eliminado"
  end
  
  def prev
    render :show
  end
  
  def next
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
  
  def authenticate_user_if_this_years_exposition(year)
    authenticate_user!  if year == Date.today.year
  end
end
