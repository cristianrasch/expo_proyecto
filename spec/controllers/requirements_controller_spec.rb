require 'spec_helper'

describe RequirementsController do
  before do 
    basic_authenticate
    sign_in Factory(:user, :admin => true)
  end
  
  it "should 'print' projects' extra requirements" do
    expo = Factory(:exposition)
    Factory(:project, :exposition => expo, :needs_projector_reason => Faker::Lorem.sentence)
    Factory(:project, :exposition => expo, :needs_screen_reason => Faker::Lorem.sentence, :needs_poster_hanger_reason => Faker::Lorem.sentence)
    requirements_file = File.join(Dir.tmpdir, 'requisitos.pdf')
    File.delete(requirements_file) if File.exists?(requirements_file)
    
    get :index, :exposition_id => expo.year
    
    response.should be_success
    File.exists?(requirements_file).should be_true
  end
end
