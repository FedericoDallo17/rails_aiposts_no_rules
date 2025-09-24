FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.unique.username }
    email { Faker::Internet.unique.email }
    password { "password123" }
    bio { Faker::Lorem.paragraph }
    website { Faker::Internet.url }
    location { Faker::Address.city }
  end
end
