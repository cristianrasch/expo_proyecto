require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ExpositionsHelper. For example:
#
# describe ExpositionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ApplicationHelper do
  it "should display a model not found message" do
    helper.not_found(Exposition).should match(/no se encontraron #{Exposition.model_name.human.pluralize}/i)
  end
end
