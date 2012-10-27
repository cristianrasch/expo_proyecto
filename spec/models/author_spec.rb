require 'spec_helper'

describe Author do
  it "should only save valid instances" do
    author = Author.new
    
    author.should be_invalid
    author.should have(1).error_on(:name)
    
    another = create(:author, :with_project)
    author.name = another.name
    author.project = another.project
    author.should be_invalid
    author.should have(1).error_on(:name)
  end
  
  it "should titleize its name before being saved" do
    author = create(:author, name: 'john grisham')
    author.name.should eq('John Grisham')
  end
end
