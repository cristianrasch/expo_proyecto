require 'spec_helper'

describe ExpositionsController do
  render_views
  
  before { sign_in create(:user) }
  
  it "should display a list of existing Expositions" do
    create_list(:exposition, 2)
    get :index
    
    response.should be_success
    response.should render_template(:index)
    assigns[:expositions].should_not be_nil
    assigns[:expositions].should_not be_empty
  end

  it "should display a new Exposition form" do
    basic_authenticate
    get :new
    
    response.should be_success
    response.should render_template(:new)
    assigns[:exposition].should_not be_nil
    assigns[:exposition].should be_a_new_record
  end
  
  context "create action" do
    before { basic_authenticate }
    
    it "should redisplay the new Exposition form when invalid params are submitted" do
      lambda {
        post :create, :exposition => {}, :date => {:year => ''}
      }.should_not change(Exposition, :count)
      
      response.should be_success
      response.should render_template(:new)
      assigns[:exposition].should_not be_nil
      assigns[:exposition].should_not be_valid
    end
    
    it "should create a new Exposition object when valid params are submitted" do
      lambda {
        post :create, :exposition => {}, :date => {:year => rand(Date.today.year+1)}
      }.should change(Exposition, :count).by(1)
      
      response.should be_redirect
      assigns[:exposition].should_not be_nil
      response.should redirect_to(exposition_path(assigns[:exposition].year))
      flash[:notice].should == "#{Exposition.model_name.human.humanize} guardada"
    end
  end
  
  it "should display the Exposition's page" do
    get :show, :id => create(:exposition).year
    
    response.should be_success
    response.should render_template(:show)
    assigns[:exposition].should_not be_nil
    assigns[:exposition].should be_valid
  end
  
  it "should display the Exposition's edit form" do
    basic_authenticate
    get :edit, :id => create(:exposition).year
    
    response.should be_success
    response.should render_template(:edit)
    assigns[:exposition].should_not be_nil
    assigns[:exposition].should be_valid
    assigns[:exposition].should be_persisted
  end
  
  context "update action" do
    before { basic_authenticate }
    
    it "should redisplay the Exposition's edit form when invalid params are submitted" do
      put :update, :id => create(:exposition), :exposition => {}, :date => {:year => ''}
      
      response.should be_success
      response.should render_template(:edit)
      assigns[:exposition].should_not be_nil
      assigns[:exposition].should be_invalid
    end
    
    it "should update an existing Exposition when valid params are submitted" do
      next_year = Date.today.year+1
      put :update, :id => create(:exposition), :exposition => {}, :date => {:year => next_year}
      
      response.should be_redirect
      response.should redirect_to(exposition_path(next_year))
      assigns[:exposition].should_not be_nil
      flash[:notice].should == "#{Exposition.model_name.human.humanize} guardada"
    end
  end
  
  it "should delete an existing Exposition" do
    basic_authenticate
    lambda {
      delete :destroy, :id => create(:exposition)
    }.should_not change(Exposition, :count)
    
    response.should be_redirect
    response.should redirect_to(expositions_path)
    flash[:notice].should == "#{Exposition.model_name.human.humanize} eliminada"
  end
end
