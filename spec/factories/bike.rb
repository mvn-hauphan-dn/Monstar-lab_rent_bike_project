# spec/factories/bike.rb

FactoryBot.define do
  factory :bike do
    name { "#{Faker::Lorem.word}-#{Faker::Lorem.word}-#{Faker::Number.number(digits: 4)}" }
    price { Faker::Number.between(from: 0, to: 500) }
    license_plates { '12-A1-12345' }
    status { :available }
    association :user
    association :category

    trait :pending do
      status { :pending }
    end

    trait :cancel do
      status { :cancel }
    end

    trait :available do
      status { :available }
    end
  end
end
