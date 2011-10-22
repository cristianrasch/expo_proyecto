require 'spec_helper'

describe Exposition do
  context "model validations" do
    it "should validate year is present" do
      expo = Exposition.new
      expo.should be_invalid
      expo.should have(1).error_on(:year)
    end
    
    it "should validate year's uniqueness" do
      Factory(:exposition, :year => Date.today.year)
      expo = Exposition.new(:year => Date.today.year)
      expo.should be_invalid
      expo.should have(1).error_on(:year)
    end
  end
  
  it "should set a default name when none was provided" do
    expo = Factory(:exposition)
    expo.name.should be_present
    expo.name.should match(/\AExpoProyecto \d+\z/)
  end
  
  it "should set default dates when none provided" do
    expo_date = 2.years.from_now.to_date
    expo = Factory(:exposition, :year => expo_date.year)
    
    expo.start_date.should_not be_blank
    expo.start_date.should == expo_date.at_beginning_of_year
    expo.end_date.should_not be_blank
    expo.end_date.should == expo_date.at_end_of_year
  end
end
