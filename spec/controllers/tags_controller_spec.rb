require 'spec_helper'

describe TagsController do
  before do 
    basic_authenticate
    sign_in Factory(:user, :admin => true)
  end
  
  it "should 'print' projects' tags" do
    expo = Factory(:exposition)
    3.times { Factory(:project, :exposition => expo) }
    tags_file = File.join(Dir.tmpdir, 'etiquetas.pdf')
    File.delete(tags_file) if File.exists?(tags_file)
    
    get :index, :exposition_id => expo.year
    
    response.should be_success
    File.exists?(tags_file).should be_true
  end
end
