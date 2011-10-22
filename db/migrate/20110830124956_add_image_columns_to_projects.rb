class AddImageColumnsToProjects < ActiveRecord::Migration
  def self.up
    remove_column :projects, :image
    
    add_column :projects, :image_file_name,    :string
    add_column :projects, :image_content_type, :string
    add_column :projects, :image_file_size,    :integer
    add_column :projects, :image_updated_at,   :datetime
  end

  def self.down
    remove_column :projects, :image_file_name
    remove_column :projects, :image_content_type
    remove_column :projects, :image_file_size
    remove_column :projects, :image_updated_at
    
    add_column :projects, :image, :string
  end
end
