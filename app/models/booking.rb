# == Schema Information
#
# Table name: bookings
#
#  id                :bigint           not null, primary key
#  booking_end_day   :date
#  booking_start_day :date
#  comment           :string
#  rating            :integer
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
class Booking < ApplicationRecord
  belongs_to :bike
  belongs_to :user

  validates :booking_start_day, presence: true, comparison: { greater_than_or_equal_to: Time.now }
  validates :booking_end_day, presence: true, comparison: { greater_than_or_equal_to: :booking_start_day }
  validate :rental_period_is_available

  def rental_period_is_available
    return if Booking.where("bike_id = ? AND booking_start_day < ? AND ? < booking_end_day", bike_id, booking_end_day, booking_start_day).blank?

    errors.add(:booking_start_day, "is already booked in this time period")
  end
end
