class AddUsersDeactivatedToExpositions < ActiveRecord::Migration
  def self.up
    add_column :expositions, :users_deactivated, :boolean, :default => false
    Exposition.reset_column_information
    Exposition.update_all(["users_deactivated = ?", false])
  end

  def self.down
    remove_column :expositions, :users_deactivated
  end
end
