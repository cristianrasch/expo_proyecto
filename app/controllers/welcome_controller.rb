class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :index
  
  def index
    @exposition = Exposition.order("year desc").first
    @activities = Activity.where(:expositions => {:year => Date.today.year}).joins(:exposition).order('date')
  end
end
