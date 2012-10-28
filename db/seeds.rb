# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


exposition = FactoryGirl.create(:exposition, year: Date.today.year)
project = FactoryGirl.create(:project, authors_count: 2, 
                              title: "QA Project", description: "Dummy test project", 
                              exposition: exposition)
FactoryGirl.create :activity, title: "Lucha de robots", exposition: exposition
FactoryGirl.create :activity, title: "Museo de electrónica", exposition: exposition
FactoryGirl.create :user, :confirmed, email: "admin@example.com", password: "secret", admin: true