FactoryBot.define do
  factory :notification do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    read { false }
    association :user
    association :notifiable, factory: :post
  end
end
