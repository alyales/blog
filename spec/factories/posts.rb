FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "title#{n}" }
    body {'very interesting body'}
  end
end
