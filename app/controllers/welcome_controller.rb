class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def index
    @exposition = Exposition.sorted.first
    @activities = @exposition.try(:activities) || []
  end
  
  def venue
  end
end
