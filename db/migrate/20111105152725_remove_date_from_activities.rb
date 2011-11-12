class RemoveDateFromActivities < ActiveRecord::Migration
  def self.up
    change_table(:activities) do |t|
      t.remove :date
      t.remove :from
      t.remove :to
    end
  end

  def self.down
    change_table(:activities) do |t|
      t.date :date
      t.string :from
      t.string :to
    end
    
    Activity.reset_column_information
    Activity.all.each do |activity|
      date = activity.starts_at.to_date
      from = activity.starts_at.strftime('%H:%M')
      to = activity.ends_at.strftime('%H:%M')
      activity.update_attributes :date => date, :from => from, :to => to
    end
  end
end
