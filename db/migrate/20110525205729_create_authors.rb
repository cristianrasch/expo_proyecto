class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :name
      t.integer :project_id

      t.datetime :created_at
    end
    
    add_index :authors, [:name, :project_id]
    add_index :authors, :project_id
  end

  def self.down
    drop_table :authors
  end
end
