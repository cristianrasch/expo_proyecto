require 'spec_helper'

describe Message do
  it "should validate instances" do
    message = Message.new :recipients => [], :subject => ""
    
    message.should_not be_valid
    message.should have(1).error_on(:recipients)
    message.should have(1).error_on(:subject)
    message.should have(1).error_on(:text)
  end
  
  it "should initialize its recipients array when an exposition param given to its initialize method" do
    project = Factory(:project, :contact => "one@example.com, ..., two@example.com")
    message = Message.new :source => project
    
    message.recipients.should_not be_empty
    message.recipients.should include("one@example.com")
    message.recipients.should include("two@example.com")
  end
end
