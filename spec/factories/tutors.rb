FactoryBot.define do
  factory :tutor do
    association :course

    name { "Rahul" }

    sequence(:email) do |n|
      "rahul#{n}@test.com"
    end
  end
end
