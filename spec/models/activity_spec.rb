require 'spec_helper'

describe Activity do
  context "model validations" do
    it "should save only valid instances" do
      activity = Activity.new
      
      activity.should be_invalid
      activity.should have(1).error_on(:title)
      activity.should have(1).error_on(:date)
      activity.should have(1).error_on(:from)
      activity.should have(1).error_on(:to)
      activity.should have(1).error_on(:exposition_id)
    end
    
    it "should validate uniqueness of title" do
      act = Factory(:activity)
      activity = Activity.new(:title => act.title, :date => act.date)
      activity.should_not be_valid
      activity.should have(1).error_on(:title)
    end
    
    it "should ensure a valid hour range" do
      activity = Factory.build(:activity, :from => '15:05', :to => '9.55')
      
      activity.should be_invalid
      activity.should have(1).error_on(:to)
    end
    
    it "should ensure a valid date" do
      expo = Factory(:exposition, :year => Date.today.year)
      activity = expo.activities.build(Factory.attributes_for(:activity, :date => 2.years.ago.to_date))
      
      activity.should be_invalid
      activity.should have(1).error_on(:date)
    end
  end
  
  it "should humanize its title before being saved" do
    Factory(:activity, :title => 'some random activity').title.should match(/\ASome/)
  end
  
  it "should return a String representation of itself" do
    activity = Factory(:activity)
    string = activity.to_s
    string.should include(activity.title)
    string.should include(I18n.l(activity.date, :format => :short))
    string.should include(activity.from)
    string.should include(activity.to)
  end
end
