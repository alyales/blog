FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "login#{n}" }
  end
end
