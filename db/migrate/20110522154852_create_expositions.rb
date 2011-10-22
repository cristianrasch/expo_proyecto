class CreateExpositions < ActiveRecord::Migration
  def self.up
    create_table :expositions do |t|
      t.integer :year
      t.string :name

      t.timestamps
    end
    
    add_index :expositions, :year, :unique => true
    add_index :expositions, :name, :unique => true
  end

  def self.down
    drop_table :expositions
  end
end
