require 'spec_helper'

describe WelcomeController do
  it "should display the welcome page" do
    year = Date.today.year
    expo = Factory(:exposition, :year => year)
    2.times { |i| 
      act = expo.activities.create(Factory.attributes_for(:activity, :date => i.days.ago.to_date))
      p act.errors if act.new_record? 
    }
    get :index
    
    response.should be_success
    response.should render_template(:index)
    assigns[:exposition].should_not be_nil
    assigns[:exposition].year.should == year 
    assigns[:activities].should_not be_nil
    assigns[:activities].should_not be_empty
  end
end
