FactoryBot.define do
  factory :tutor do
    association :course

    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
  end
end
