class AddTitleExpositionIdIdxToActivities < ActiveRecord::Migration
  def self.up
    add_index :activities, [:title, :exposition_id]
  end

  def self.down
    remove_index :activities, [:title, :exposition_id]
  end
end
