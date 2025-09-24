FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph }
    tags { Faker::Lorem.words(number: 3).join(", ") }
    association :user
  end
end
