require 'spec_helper'

describe MessagesController do
  render_views

  before do
    sign_in Factory(:user, :admin => true)
    basic_authenticate
  end

  it "should display a new message form" do
    get :new, :exposition_id => Factory(:exposition).id
    
    response.should be_success
    response.should render_template(:new)
    assigns[:source].should_not be_nil
  end
  
  describe "create action" do
    context "when invalid params are submitted" do
      it "should redisplay the new message form" do
        lambda {
          post :create, :exposition_id => Factory(:exposition), :message => {}
        }.should_not change(ActionMailer::Base.deliveries, :length)
        
        response.should be_success
        response.should render_template(:new)
        assigns[:message].should_not be_nil
        assigns[:message].should be_invalid
      end
    end
    
    context "when valid params are submitted" do
      it "should send the message" do
        source = Factory(:project)
        lambda {
          post :create, :project_id => source, 
               :message => {:recipients => ["one@example.org", "two@example.org"], 
                            :subject => "..", :text => "..."}
        }.should change(ActionMailer::Base.deliveries, :length).by(1)
        
        response.should be_redirect
        response.should redirect_to(source)
        assigns[:message].should_not be_nil
        assigns[:message].should be_valid
        flash[:notice].should == "Mensaje enviado!"
      end
    end
  end
end
