require 'spec_helper'

describe VenueController do
  describe "GET 'index'" do
    it "should show the venue information" do
      get 'index'
      response.should be_success
    end
  end
end