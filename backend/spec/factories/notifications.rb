FactoryBot.define do
  factory :notification do
    message { "MyText" }
    notification_type { "MyString" }
    read_at { "2025-11-01 19:52:26" }
    user { nil }
    actor_id { 1 }
  end
end
