class AddApprovalTimePositionToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :approval_time, :integer
    add_column :projects, :position, :integer
  end

  def self.down
    remove_column :projects, :position
    remove_column :projects, :approval_time
  end
end
