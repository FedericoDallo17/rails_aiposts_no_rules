FactoryBot.define do
  factory :post do
    content { "This is a test post" }
    tags { "test, sample" }
    association :user
  end
end
