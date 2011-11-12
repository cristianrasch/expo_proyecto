class TagsController < ApplicationController
  before_filter :ensure_admin_logged_in!
  
  def index
    @exposition = Exposition.find_by_year(params[:exposition_id])
    send_data @exposition.print_projects_tags, :filename => 'etiquetas.pdf', :type => 'application/pdf'
  end
end
