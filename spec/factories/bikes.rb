# == Schema Information
#
# Table name: bikes
#
#  id             :bigint           not null, primary key
#  description    :string
#  license_plates :string
#  name           :string
#  price          :float
#  status         :integer          default("pending")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  admin_id       :bigint
#  category_id    :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_bikes_on_admin_id        (admin_id)
#  index_bikes_on_category_id     (category_id)
#  index_bikes_on_license_plates  (license_plates) UNIQUE
#  index_bikes_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (admin_id => admins.id)
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
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
