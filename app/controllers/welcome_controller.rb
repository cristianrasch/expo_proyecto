class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :index
  
  def index
    @exposition = Exposition.sorted.first
    @activities = @exposition.try(:activities) || []
  end
end
