# frozen_string_literal: true

# == Schema Information
#
# Table name: booking_statuses
#
#  id         :bigint           not null, primary key
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  booking_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_booking_statuses_on_booking_id  (booking_id)
#  index_booking_statuses_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (booking_id => bookings.id)
#  fk_rails_...  (user_id => users.id)
#
# spec/factories/booking_statuses.rb

FactoryBot.define do
  factory :booking_status do
    association :booking
    association :user
    status { BookingStatus.statuses.keys.sample }
  end
end
