# frozen_string_literal: true

# == Schema Information
#
# Table name: bookings
#
#  id                :bigint           not null, primary key
#  booking_end_day   :date
#  booking_start_day :date
#  comment           :string
#  rating            :integer
#  status            :integer          default("pending")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  bike_id           :bigint
#  user_id           :bigint
#
# Indexes
#
#  index_bookings_on_bike_id  (bike_id)
#  index_bookings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (bike_id => bikes.id)
#  fk_rails_...  (user_id => users.id)
#
# spec/factories/booking.rb

FactoryBot.define do
  factory :booking do
    booking_start_day { Time.zone.now + 1.day }
    booking_end_day { Time.zone.now + 2.day }
    comment { Faker::Lorem.word }
    rating { Faker::Number.between(from: 1, to: 5) }
    status { :pending }
    association :user
    association :bike
  end
end
