require 'spec_helper'

describe TagsController do
  before do 
    basic_authenticate
    sign_in Factory(:user, :admin => true)
  end
  
  it "should 'print' projects' tags" do
    expo = Factory(:exposition)
    3.times { Factory(:project, :exposition => expo) }
    get :index, :exposition_id => expo.year
    
    response.should be_success
  end
end
