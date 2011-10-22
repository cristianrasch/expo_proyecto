class AddOtherFacultyToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :other_faculty, :string
  end

  def self.down
    remove_column :projects, :other_faculty
  end
end
