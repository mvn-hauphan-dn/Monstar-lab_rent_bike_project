# spec/factories/bike.rb

FactoryBot.define do
  factory :bike do
    name { Faker::Vehicle.model }
    price { Faker::Number.between(from: 50, to: 500) }
    license_plates { Faker::Vehicle.license_plate }
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