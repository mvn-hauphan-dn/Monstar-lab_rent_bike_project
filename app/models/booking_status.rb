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
class BookingStatus < ApplicationRecord
  belongs_to :booking
  belongs_to :user

  enum status: %i[pending booking cancel payment finished]
end
