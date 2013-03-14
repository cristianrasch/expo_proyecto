# encoding: utf-8

require 'spec_helper'

describe Project do
  context "model validations" do
    it "requires some attributes to be present" do
      project = Project.new(:needs_projector => "1", :faculty => -1)
      
      project.should be_invalid
      [:title, :subject, :group_type, :contact, :expo_mode, 
       :description, :author_ids, :needs_projector_reason, :other_faculty].each { |attr|
        project.should have(1).error_on(attr)
      }
    end

    it "can't add new projects once the exposition has finished" do
      exposition = create(:exposition, year: 2012, start_date: Date.civil(2012, 6, 1), end_date: Date.civil(2012, 6, 3))
      project = build(:project, exposition: exposition)
      project.should be_invalid
      project.errors[:base].should include("La exposición ha finalizado")
    end
  end
  
  context "authors attributes assignment" do
    before { @project = create(:project) }
    
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
    project = build(:project, :title => 'my n1f7y, little project')
    filename = project.filename
    filename.should include(project.exposition.year.to_s)
    filename.should match(/my_n1f7y__little_project/i)
  end
  
  it "should return its formatted authors' names" do
    project = create(:project, authors_count: 2)
    authors = project.send(:authors_names)
    project.authors.each { |author| authors.should include(author.name) }
  end
  
  it "should return a PDF representation of itself" do
    build(:project).to_pdf.should_not be_blank
  end
  
  describe "when paginating projects" do
    before(:all) do
      @exposition = create(:exposition_with_projects, projects_count: 4)
      @projects = @exposition.projects
    end

    after(:all) do
      @exposition.destroy
    end
    
    context "and we ask for the next project" do
      it "should return the closest next project" do
        project = Project.find_next(@projects.first.slug, @exposition.id)
        project.should eq(@projects.second)
      end
      
      it "should return the first project when the end of the list is reached" do
        project = Project.find_next(@projects.last.slug, @exposition.id)
        project.should eq(@projects.first)
      end
    end
    
    context "and we ask for the previous project" do
      it "should return the closest previous project" do
        project = Project.find_prev(@projects.second.slug, @exposition.id)
        project.should eq(@projects.first)
      end
      
      it "should return the last project when the end of the list is reached" do
        project = Project.find_prev(@projects.first.slug, @exposition.id)
        project.should eq(@projects.last)
      end
    end
  end
  
  context "approval_time accessor methods" do
    before { @project = build(:project, :expo_mode => Conf.expo_modes['ROBOT SUMO']) }
    
    it "should format the read attr" do
      @project.approval_time = '2:34'
      @project.approval_time.should == '02:34'
    end
    
    it "should turn time into seconds" do
      @project.approval_time = '2:10'
      @project.send(:read_attribute, :approval_time).should == 130
    end
  end

  {bmp: 'apple.bmp', gif: 'logo_multimarket.gif'}.each do |image_ext, test_fixture|
    it "should reject #{image_ext} images" do
      project = build(:project)
      project.image = Rails.root.join("spec/support/files/#{test_fixture}").open
      
      project.should be_invalid
      project.errors[:image_content_type].should be_present
    end
  end

  it "should accept jpeg images" do
    project = build(:project)
    project.image = Rails.root.join('spec/support/files/cartel-led.jpeg').open
    
    project.should be_valid
  end
end
