class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :title
      t.date :date
      t.string :from
      t.string :to
      t.integer :exposition_id

      t.timestamps
    end
    
    add_index :activities, [:title, :date]
    add_index :activities, :exposition_id
  end

  def self.down
    drop_table :activities
  end
end
