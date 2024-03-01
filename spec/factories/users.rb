# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  activated_at      :datetime
#  activation_digest :string
#  address           :string
#  email             :string
#  name              :string
#  password_digest   :string
#  phone_number      :string
#  remember_digest   :string
#  reset_digest      :string
#  reset_sent_at     :datetime
#  role              :integer          default("renter")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
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
