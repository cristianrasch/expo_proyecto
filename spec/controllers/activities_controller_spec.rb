require 'spec_helper'

describe ActivitiesController do
  render_views
  
  before do 
    sign_in create(:user, :admin => true)
    basic_authenticate
  end
  
  it "should deny access to non-admin users" do
    request.env['HTTP_AUTHORIZATION'] = nil
    get :index, :exposition_id => create(:exposition).year
    
    response.status.should == 401
  end
  
  it "should display Exposition's activities" do
    get :index, :exposition_id => create(:exposition).year
    
    response.should be_success
    response.should render_template(:index)
    assigns[:exposition].should_not be_nil
    assigns[:activities].should_not be_nil
  end
  
  it "should display a new Activity form" do
    get :new, :exposition_id => create(:exposition).year
    
    response.should be_success
    response.should render_template(:new)
    assigns[:exposition].should_not be_nil
    assigns[:activity].should_not be_nil
    assigns[:activity].exposition_id.should == assigns[:exposition].id
  end
  
  context "create action" do
    before { @exposition = create(:exposition, :year => Date.today.year) }
    
    it "should redisplay the new Activity form when invalid params are submitted" do
      lambda {
        post :create, :exposition_id => @exposition, :activity => {}
      }.should_not change(@exposition.activities, :count)
      
      response.should be_success
      response.should render_template(:new)
      assigns[:exposition].should_not be_nil
      assigns[:activity].should_not be_nil
      assigns[:activity].should_not be_valid
    end
    
    it "should create a new Activity when valid params are submitted" do
      lambda {
        post :create, :exposition_id => @exposition, 
             :activity => attributes_for(:activity, exposition: @exposition)
      }.should change(@exposition.activities, :count).by(1)
      
      response.should be_redirect
      response.should redirect_to(exposition_activities_path(@exposition.year))
      assigns[:exposition].should_not be_nil
      assigns[:activity].should_not be_nil
      flash[:notice].should == "#{Activity.model_name.human.humanize} guardada"
    end
  end
  
  it "should display the Activity's page" do
    get :show, :id => create(:activity)
    
    response.should be_success
    response.should render_template(:show)
    assigns[:activity].should_not be_nil
    assigns[:activity].should be_valid
  end
  
  it "should display the Activity's edit form" do
    get :edit, :id => create(:activity)
    
    response.should be_success
    response.should render_template(:edit)
    assigns[:activity].should_not be_nil
  end
  
  context "update action" do
    it "should redisplay Activity's edit form when invalid params are submitted" do
      put :update, :id => create(:activity), :activity => {:title => ''}
      
      response.should be_success
      response.should render_template(:edit)
      assigns[:activity].should_not be_nil
      assigns[:activity].should_not be_valid
    end
    
    it "should update an existing Activity when valid params are submitted" do
      activity = create(:activity)
      put :update, :id => activity, :activity => {:title => '..'}
      
      response.should be_redirect
      response.should redirect_to(exposition_activities_path(activity.exposition.year))
      assigns[:activity].should_not be_nil
      assigns[:activity].title.should == '..'
      flash[:notice].should == "#{Activity.model_name.human.humanize} guardada"
    end
  end

  it "should delete an existing Activity" do
    activity = create(:activity)
    lambda {
      delete :destroy, :id => activity
    }.should change(Activity, :count).by(-1)
    
    response.should be_redirect
    response.should redirect_to(exposition_activities_path(activity.exposition.year))
    assigns[:activity].should_not be_nil
    assigns[:activity].should be_destroyed
    flash[:notice].should == "#{Activity.model_name.human.humanize} eliminada"
  end
end
