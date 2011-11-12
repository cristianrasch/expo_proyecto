Factory.define :exposition do |e|
  e.year { rand(Date.today.year) }
end

Factory.define :project do |p|
  p.title { Faker::Company.name }
  p.faculty Conf.faculties.values.first
  p.subject { Faker::Lorem.sentence }
  p.group_type Conf.group_types.values.first
  p.contact Faker::Internet.email
  p.expo_mode Conf.expo_modes.values.first
  p.description Faker::Lorem.paragraph
  
  p.association :exposition
  p.association :user
  p.after_build { |pp| 3.times { pp.authors << Factory(:author, :project => pp) } }
end

Factory.define :author do |a|
  a.name { Faker::Name.name }
  
  a.association :project
end

Factory.define :activity do |a|
  a.title { Faker::Lorem.word }
  a.exposition { Factory(:exposition) }
  a.starts_at { |aa| Date.civil(aa.exposition.year, 5, 29) }
  a.ends_at { |aa| Date.civil(aa.exposition.year, 9, 11) }
end

Factory.define :user do |u|
  u.email { Faker::Internet.email }
  u.password { ActiveSupport::SecureRandom.hex(5) }
  u.password_confirmation { |uu| uu.password }
  u.confirmed_at 1.hour.ago
end
