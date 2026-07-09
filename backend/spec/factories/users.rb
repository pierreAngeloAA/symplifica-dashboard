FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@symplifica.com" }
    password { "password123" }
  end
end
