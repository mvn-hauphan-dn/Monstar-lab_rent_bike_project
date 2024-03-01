# spec/factories/bike.rb

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
    role { :renter }
    address { Faker::Address.full_address }
    phone_number { Faker::PhoneNumber.phone_number }
    activated_at { Time.zone.now }

    trait :lessor do
      role { :lessor }
    end
  end
end