class Calendar < ApplicationRecord
  belongs_to :bike

  validates :start_day, presence: true, comparison: { greater_than_or_equal_to: Time.now }
  validates :end_day, presence: true, comparison: { greater_than_or_equal_to: :start_day }
  validate :rental_period_is_available

  scope :load_calendar_by_month, -> (month, year){ where('EXTRACT(MONTH FROM start_day) = ? AND EXTRACT(YEAR FROM start_day) = ?', month, year) }

  def rental_period_is_available
    return if Calendar.where("bike_id = ? AND start_day < ? AND ? < end_day", bike_id, end_day, start_day).blank?

    errors.add(:start_day, "Bike is already booked in this time period")
  end
end
