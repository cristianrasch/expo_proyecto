require 'spec_helper'

describe WelcomeController do
  it "should display the welcome page" do
    exposition = Factory(:exposition)
    2.times do |i| 
      Factory :activity, :exposition => exposition
    end
    get :index
    
    response.should be_success
    response.should render_template(:index)
    assigns[:exposition].should_not be_nil
    assigns[:activities].should_not be_nil
    assigns[:activities].should_not be_empty
  end
  
  it "should show the venue information" do
    get :venue
    
    response.should be_success
    response.should render_template(:venue)
  end
end