class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :title
      t.integer :faculty, :limit => 1
      t.string :subject
      t.integer :group_type, :limit => 1
      t.boolean :competes_to_win_prizes, :default => false
      t.string :contact
      t.integer :expo_mode, :limit => 1
      t.text :description

      t.references :exposition

      t.timestamps
    end
    
    add_index :projects, [:title, :exposition_id]
    add_index :projects, :exposition_id
  end

  def self.down
    drop_table :projects
  end
end
