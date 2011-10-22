require 'spec_helper'

describe ProjectsImporter do
  it "should import legacy projects" do
    logger = File.join(Rails.root, "log", "legacy_projects_import.log")
    File.delete(logger) if File.exists?(logger)
    
    lambda {
      lambda {
        ProjectsImporter.import_legacy_projects
      }.should change(Project, :count).by(2)
    }.should change(Exposition, :count).by(1)
    
    File.exists?(logger).should be_true
  end
end
