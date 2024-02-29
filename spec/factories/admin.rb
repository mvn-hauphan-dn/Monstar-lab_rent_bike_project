# spec/factories/admins.rb

FactoryBot.define do
  factory :admin do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    role { :admin }

    trait :root do
      role { :root }
    end
  end
end
