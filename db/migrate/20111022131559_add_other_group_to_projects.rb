class AddOtherGroupToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :other_group, :string
  end

  def self.down
    remove_column :projects, :other_group
  end
end
