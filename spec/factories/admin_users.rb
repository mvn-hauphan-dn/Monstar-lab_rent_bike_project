# frozen_string_literal: true

# == Schema Information
#
# Table name: admin_users
#
#  id              :bigint           not null, primary key
#  email           :string
#  name            :string
#  password_digest :string
#  remember_digest :string
#  role            :integer          default("admin")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email  (email) UNIQUE
#

FactoryBot.define do
  factory :admin_user do
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
