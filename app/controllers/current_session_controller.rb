class CurrentSessionController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :show
  
  def show
    render :show, layout: false
  end
end