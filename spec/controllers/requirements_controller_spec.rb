require 'spec_helper'

describe RequirementsController do
  before do 
    basic_authenticate
    sign_in create(:user, :admin => true)
  end
  
  it "should 'print' projects' extra requirements" do
    expo = create(:exposition)
    create(:project, :exposition => expo, :needs_projector_reason => Faker::Lorem.sentence)
    create(:project, :exposition => expo, 
            :needs_screen_reason => Faker::Lorem.sentence, 
            :needs_poster_hanger_reason => Faker::Lorem.sentence)
    get :index, :exposition_id => expo.year
    
    response.should be_success
  end
end
