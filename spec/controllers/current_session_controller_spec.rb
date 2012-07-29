require 'spec_helper'

describe CurrentSessionController do
  render_views
  
  it "links to the log in page if the user hasn't yet signed in" do
    get :show
    
    response.should be_success
    response.body.should =~ Regexp.new(new_user_session_path)
  end
  
  it "returns a log out link if the user has already signed in" do
    sign_in Factory(:user)
    get :show
    
    response.should be_success
    response.body.should =~ Regexp.new(destroy_user_session_path)
  end
end