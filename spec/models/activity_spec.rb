require 'spec_helper'

describe Activity do
  context "model validations" do
    it "should save only valid instances" do
      activity = Activity.new
      
      activity.should be_invalid
      activity.should have(1).error_on(:title)
      activity.should have(1).error_on(:starts_at)
      activity.should have(1).error_on(:ends_at)
      activity.should have(1).error_on(:exposition_id)
    end
    
    it "should validate uniqueness of title" do
      activity = Factory(:activity)
      new_activity = activity.exposition.activities.build(:title => activity.title)
      
      new_activity.should_not be_valid
      new_activity.should have(1).error_on(:title)
    end
    
    it "should validate its date range" do
      activity = Factory.build(:activity)
      activity.ends_at = activity.starts_at - 1.month
      
      activity.should be_invalid
      activity.should have(1).error_on(:ends_at)
    end
    
    it "should be valid for its exposition's year" do
      exposition = Factory(:exposition, :year => Date.today.year)
      activity = exposition.activities.build(Factory.attributes_for(:activity, :starts_at => 2.years.ago.to_date))
      
      activity.should be_invalid
      activity.should have(1).error_on(:starts_at)
    end
  end
  
  it "should return a String representation of itself" do
    activity = Factory(:activity)
    string = activity.to_s
    
    string.should include(activity.title)
    string.should include(I18n.l(activity.starts_at, :format => :short))
  end
end
