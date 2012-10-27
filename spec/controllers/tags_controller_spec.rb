require 'spec_helper'

describe TagsController do
  before do 
    basic_authenticate
    sign_in create(:user, :admin => true)
  end
  
  it "should 'print' projects' tags" do
    expo = create(:exposition)
    create_list(:project, 3, exposition: expo)
    get :index, :exposition_id => expo.year
    
    response.should be_success
  end
end
