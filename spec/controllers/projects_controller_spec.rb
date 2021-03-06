require 'spec_helper'

describe ProjectsController do
  render_views
  
  before { sign_in create(:user) }
  
  context "index action" do
    before { @expo = create(:exposition) }
    
    it "should search for projects" do
      2.times { |i| create :project, :title => "Project ##{i}", :exposition => @expo }
      get :index, :exposition_id => @expo.year, :project => { :title => 'project' }
      
      response.should be_success
      response.should render_template(:index)
      assigns[:exposition].should_not be_nil
      assigns[:projects].should_not be_nil
      assigns[:projects].should have(2).projects
    end
    
    it "should concat all projects' pdf files into a single one" do
      2.times { create :project, :exposition => @expo }
      get :index, :exposition_id => @expo.year, :format => :pdf
      
      response.should be_success
      assigns[:exposition].should_not be_nil
    end
  end
  
  it "should display a gallery of projects" do
    expo = create(:exposition)
    2.times { create :project, :exposition => expo }
    get :gallery, :exposition_id => expo.year
    
    response.should be_success
    response.should render_template(:gallery)
    assigns[:exposition].should_not be_nil
    assigns[:projects].should_not be_nil
    assigns[:projects].should_not be_empty
  end
  
  it "should display a new Project form" do
    get :new, :exposition_id => create(:exposition).year
    
    response.should be_success
    response.should render_template(:new)
    assigns[:exposition].should_not be_nil
    assigns[:project].should_not be_nil
    assigns[:project].exposition_id.should == assigns[:exposition].id
  end
  
  context "create action" do
    before { @exposition = create(:exposition) }
    
    it "should redisplay the new Project form when invalid params are submitted" do
      lambda {
        post :create, :exposition_id => @exposition, :project => {}
      }.should_not change(@exposition.projects, :count)
      
      response.should be_success
      response.should render_template(:new)
      assigns[:exposition].should_not be_nil
      assigns[:project].should_not be_nil
      assigns[:project].should_not be_valid
    end
    
    it "should create a new Project when valid params are submitted" do
      lambda {
        post :create, :exposition_id => @exposition, 
             :project => attributes_for(:project).merge(:authors_attributes => {1 => { :name => Faker::Name.name }}, 
                                                :image => test_image)
      }.should change(@exposition.projects, :count).by(1)
      
      response.should be_redirect
      response.should redirect_to(exposition_projects_path(@exposition.year))
      assigns[:exposition].should_not be_nil
      assigns[:project].should_not be_nil
      assigns[:project].image.url.should_not be_nil
      assigns[:project].image.url.should match(/add\.png/)
      flash[:notice].should == "#{Project.model_name.human.humanize} guardado"
    end
  end
  
  context "show action" do
    it "should display Project's page" do
      get :show, :id => create(:project)
      
      response.should be_success
      response.should render_template(:show)
      assigns[:project].should_not be_nil
      assigns[:project].should be_valid
    end
    
    it "should display Project's PDF representation" do
      get :show, :id => create(:project), :format => :pdf
      
      response.should be_success
      assigns[:project].should_not be_nil
      assigns[:project].should be_valid
    end
  end
  
  context "edit action" do
    before do
      sign_out :user
      sign_in user
    end
    
    context "when a regular user is logged in" do
      let(:user) { create(:user) }
      
      it "should not be able to edit another one's project" do
        project = create(:project)
        get :edit, :id => project
        
        response.should be_redirect
        response.should redirect_to(exposition_projects_path(project.exposition.year))
        flash[:alert].should == "Acceso denegado!"
        assigns[:project].should_not be_nil
      end
    end
    
    context "when a project owner is logged in" do
      let(:user) { create(:project, :with_user).user }
      
      it "should be able to edit his/her projects" do
        get :edit, :id => user.projects.last
        
        response.should be_success
        response.should render_template(:edit)
        assigns[:project].should_not be_nil
      end
    end
  end
  
  context "update action" do
    before do
      sign_out :user
      sign_in user
    end
    
    context "when invalid params are submitted" do
      let(:user) { create(:project, :with_user).user }
      
      it "should redisplay Project's edit form" do
        put :update, :id => user.projects.last, :project => {:title => ''}
        
        response.should be_success
        response.should render_template(:edit)
        assigns[:project].should_not be_nil
        assigns[:project].should_not be_valid
      end
    end
    
    context "when valid params are submitted" do
      let(:user) { create(:project, :with_user, :image => test_image).user }
      
      it "should update an existing Project" do
        project = user.projects.last
        put :update, :id => project, :project => {:title => '..', :remove_image => "1"}
        
        response.should be_redirect
        response.should redirect_to(exposition_projects_path(project.exposition.year))
        assigns[:project].should_not be_nil
        assigns[:project].title.should == '..'
        assigns[:project].image.url.should == "/images/default.gif"
        flash[:notice].should == "#{Project.model_name.human.humanize} guardado"
      end
    end
  end

  it "should delete an existing Project" do
    sign_out :user
    project = create(:project, :with_user)
    sign_in project.user
    lambda {
      delete :destroy, :id => project
    }.should change(Project, :count).by(-1)
    
    response.should be_redirect
    response.should redirect_to(exposition_projects_path(project.exposition.year))
    assigns[:project].should_not be_nil
    assigns[:project].should be_destroyed
    flash[:notice].should == "#{Project.model_name.human.humanize} eliminado"
  end
  
  [:prev, :next].each do |action|
    it "should display the #{action} project on the list" do
      project = create(:project)
      get action, :id => project.slug, :exposition_id => project.exposition_id
      
      response.should be_success
      response.should render_template(:show)
      assigns[:project].should_not be_nil
    end
  end
end
