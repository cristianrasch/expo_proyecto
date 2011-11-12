require 'spec_helper'

describe User do
  context "should deactivate expired accounts" do
    before do
      @exposition = Factory(:exposition, :year => 2.years.ago.year)
      Factory(:project, :exposition => @exposition, :user => user)
    end
    
    context "when user is an admin" do
      let(:user) { Factory(:user, :admin => true) }
      
      it "should not be deactivated" do
        User.deactivate_expired_accounts
        user.reload.should be_active
        @exposition.reload.users_deactivated.should be_true
      end
    end
    
    context "when user is just a regular user" do
      let(:user) { Factory(:user) }
     
      it "should be deactivated" do
        User.deactivate_expired_accounts
        user.reload.should_not be_active
        @exposition.reload.users_deactivated.should be_true
      end
    end
  end
end
