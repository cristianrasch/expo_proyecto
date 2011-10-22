class AddDatesToExpositions < ActiveRecord::Migration
  def self.up
    add_column :expositions, :start_date, :date
    add_column :expositions, :end_date, :date
    
    add_index :expositions, [:start_date, :end_date]
    
    Exposition.reset_column_information
    today = Date.today
    Exposition.where(:start_date => nil).find_each do |exposition|
      date = today.advance(:years => exposition.year - today.year)
      exposition.update_attributes(:start_date => date.at_beginning_of_year, 
                                   :end_date => date.at_end_of_year)
    end
  end

  def self.down
    remove_index :expositions, [:start_date, :end_date]
    
    remove_column :expositions, :end_date
    remove_column :expositions, :start_date
  end
end
