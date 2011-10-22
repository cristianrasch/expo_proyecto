require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ProjectsHelper. For example:
#
# describe ProjectsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ProjectsHelper do
  %w{faculty group_type expo_mode}.each do |method|
    it "should return a double array of #{method} options" do
      arr = helper.send("#{method}_options")
      arr.each { |e|
        e.first.should be_a(String)
        e.last.should be_a(Fixnum)
      }
    end
  end
  
  it "should escape email addresses from contact strings" do
    contact = "zz, one@example.com, .., two@example.com, xx"
    escaped_contact = helper.escape_emails(contact)
    
    escaped_contact.should_not match(/@/)
    escaped_contact.should include("one__AT__example.com")
    escaped_contact.should include("two__AT__example.com")
  end
end
