FactoryGirl.define do
  factory :exposition do
    year { (10.years.ago.year..Date.today.year).to_a.sample }
    # year { rand(Date.today.year) }

    factory :exposition_with_projects do
      ignore do
        projects_count 1
      end

      after(:create) do |exposition, evaluator|
        FactoryGirl.create_list :project, evaluator.projects_count, exposition: exposition
      end
    end
  end

  factory :project do
    title { Faker::Company.name }
    faculty Conf.faculties.values.first
    subject Faker::Lorem.sentence
    group_type Conf.group_types.values.first
    contact Faker::Internet.email
    expo_mode Conf.expo_modes.values.first
    description Faker::Lorem.paragraph
    
    exposition
    
    trait :with_user do
      user
    end

    ignore do
      authors_count 1
    end

    after(:build) do |project, evaluator|
      evaluator.authors_count.times do
        project.authors.build FactoryGirl.attributes_for(:author)
      end
    end
  end

  factory :author do
    name { Faker::Name.name }
    
    trait :with_project do
      project
    end
  end

  factory :activity do
    title { Faker::Lorem.sentence }
    starts_at { Date.civil(exposition.year, 5, 29) }
    ends_at { Date.civil(exposition.year, 9, 11) }

    exposition
  end

  factory :user do
    email { Faker::Internet.email }
    password { ActiveSupport::SecureRandom.hex(5) }
    password_confirmation { password }
    
    trait :confirmed do
      confirmed_at 1.hour.ago
    end
  end
end
