class AddStartsAtEndsAtToActivities < ActiveRecord::Migration
  class Activity < ActiveRecord::Base; end
  
  def self.up
    add_column :activities, :starts_at, :datetime
    add_column :activities, :ends_at, :datetime
    
    Activity.reset_column_information
    Activity.all.each do |activity|
      date = activity.date.to_datetime
      from = activity.from.split(':').map(&:to_i)
      to = activity.to.split(':').map(&:to_i)
      activity.update_attributes :starts_at => Time.zone.local_to_utc(date.advance(:hours => from.first, :minutes => from.second)),
                                 :ends_at => Time.zone.local_to_utc(date.advance(:hours => to.first, :minutes => to.second))
    end
  end

  def self.down
    remove_column :activities, :ends_at
    remove_column :activities, :starts_at
  end
end
