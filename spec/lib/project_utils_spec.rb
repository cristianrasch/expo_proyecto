require 'spec_helper'

describe ProjectUtils do
  before do
    @obj = Object.new
    @obj.extend(ProjectUtils)
  end
  
  %w{faculty group_type expo_mode}.each do |method|
    it "should return the #{method} desc for a given value" do
      @obj.send("#{method}_desc", Conf.send(method.pluralize).first.last).should be_present
    end
  end
end
