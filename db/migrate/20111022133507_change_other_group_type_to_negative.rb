class ChangeOtherGroupTypeToNegative < ActiveRecord::Migration
  def self.up
    Project.update_all "group_type = -1", "group_type = 8"
    Project.update_all ["other_group = ?", "Otro"], "group_type = -1 and other_group is null"
  end

  def self.down
    Project.update_all "other_group = null", ["group_type = ? and other_group = ?", -1, "Otro"]
    Project.update_all "group_type = 8", "group_type = -1"
  end
end
