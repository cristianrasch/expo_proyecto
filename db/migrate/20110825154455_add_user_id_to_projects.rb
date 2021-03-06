class AddUserIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :user_id, :integer
    add_index :projects, :user_id
  end

  def self.down
    remove_index :projects, :user_id
    remove_column :projects, :user_id
  end
end
