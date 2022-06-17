class Booking < ApplicationRecord
  belongs_to :bike
  belongs_to :user

  validates :booking_start_day, presence: true, comparison: { greater_than_or_equal_to: Time.now }
  validates :booking_end_day, presence: true, comparison: { greater_than_or_equal_to: :booking_start_day }
end
