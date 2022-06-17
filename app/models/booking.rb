class Booking < ApplicationRecord
  belongs_to :bike
  belongs_to :user
  has_many :booking_statuses

  validates :booking_start_day, presence: true, comparison: { greater_than_or_equal_to: Time.now }
  validates :booking_end_day, presence: true, comparison: { greater_than_or_equal_to: :booking_start_day }
  validate :rental_period_is_available

  def rental_period_is_available
    return if Booking.where("bike_id = ? AND booking_start_day < ? AND ? < booking_end_day", bike_id, booking_end_day, booking_start_day).blank?

    errors.add(:booking_start_day, "is already booked in this time period")
  end
end
