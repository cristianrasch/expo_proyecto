require 'spec_helper'

describe Project do
  it "should save only valid instances" do
    project = Project.new(:needs_projector => "1", :faculty => -1)
    
    project.should be_invalid
    [:title, :subject, :group_type, :contact, :expo_mode, 
     :description, :author_ids, :needs_projector_reason, :other_faculty].each { |attr|
      project.should have(1).error_on(attr)
    }
  end
  
  context "authors attributes assignment" do
    before { @project = Factory(:project) }
    
    it "should delete an author" do
      lambda {
        @project.authors_attributes = {1 => {'id' => @project.authors.first.id, '_destroy' => '1'}}
      }.should change(@project.authors, :count).by(-1)
    end
    
    it "should update an author" do
      author = @project.authors.first
      new_name = Faker::Name.name
      
      @project.authors_attributes = {1 => {'id' => author.id, 'name' => new_name}}
      
      author.reload.name.should eq(new_name)
    end
    
    it "should create an author" do
      lambda {
        @project.update_attribute(:authors_attributes, {1 => {'name' => Faker::Name.name.titleize}})
      }.should change(@project.authors, :count).by(1)
    end
  end
  
  it "should return a valid pdf filename" do
    project = Factory(:project, :title => 'my n1f7y, little project')
    filename = project.filename
    filename.should include(project.exposition.year.to_s)
    filename.should match(/my_n1f7y__little_project/i)
  end
  
  it "should return its formatted authors' names" do
    project = Factory(:project)
    2.times { project.authors << Factory(:author, :name => Faker::Name.name) }
    authors = project.send(:authors_names)
    project.authors.each { |author| authors.should include(author.name) }
  end
  
  it "should return its identifier" do
    project = Factory(:project)
    id = project.send(:identifier)
    id.should include(project.exposition.year.to_s)
    id.should include(project.id.to_s)
  end
  
  it "should return a PDF representation of itself" do
    Factory(:project).to_pdf.should_not be_blank
  end
  
  describe "when paginating projects" do
    before(:all) do
      @exposition = Factory(:exposition)
      @projects = []
      4.times { @projects << Factory(:project, :exposition => @exposition) }
      @projects.reverse!
    end
    
    context "and we ask for the next project" do
      it "should return the closest next project" do
        project = Project.find_next(@projects.first.id, @exposition.id)
        project.should eq(@projects.second)
      end
      
      it "should return the first project when the end of the list is reached" do
        project = Project.find_next(@projects.last.id, @exposition.id)
        project.should eq(@projects.first)
      end
    end
    
    context "and we ask for the previous project" do
      it "should return the closest previous project" do
        project = Project.find_prev(@projects.second.id, @exposition.id)
        project.should eq(@projects.first)
      end
      
      it "should return the last project when the end of the list is reached" do
        project = Project.find_prev(@projects.first.id, @exposition.id)
        project.should eq(@projects.last)
      end
    end
  end
  
  context "approval_time accessor methods" do
    before { @project = Factory.build(:project, :expo_mode => Conf.expo_modes['ROBOT SUMO']) }
    
    it "should format the read attr" do
      @project.approval_time = '2:34'
      @project.approval_time.should == '02:34'
    end
    
    it "should turn time into seconds" do
      @project.approval_time = '2:10'
      @project.send(:read_attribute, :approval_time).should == 130
    end
  end

  it "should reject bmp images" do
    project = Factory.build(:project)
    project.image = Rails.root.join('spec/support/files/apple.bmp').open
    
    project.should be_invalid
    project.errors[:image_content_type].should be_present
  end
end
