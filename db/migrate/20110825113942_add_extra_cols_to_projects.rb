class AddExtraColsToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :requirements, :text
    add_column :projects, :lab_gear, :text
    add_column :projects, :sockets_count, :integer, :default => 0
    add_column :projects, :needs_projector_reason, :text
    add_column :projects, :needs_screen_reason, :text
    add_column :projects, :needs_poster_hanger_reason, :text
  end

  def self.down
    remove_column :projects, :needs_poster_hanger_reason
    remove_column :projects, :needs_screen_reason
    remove_column :projects, :needs_projector_reason
    remove_column :projects, :sockets_count
    remove_column :projects, :lab_gear
    remove_column :projects, :requirements
  end
end
