FactoryBot.define do
  factory :ip do
    sequence(:address) { |n| "127.127.127.#{n}" }
  end
end

