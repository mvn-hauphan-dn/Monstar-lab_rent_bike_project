class Calendar < ApplicationRecord
  belongs_to :bike

  validates :start_day, presence: true, comparison: { greater_than_or_equal_to: Time.now }
  validates :end_day, presence: true, comparison: { greater_than_or_equal_to: :start_day }
  validate :rental_period_is_available

  scope :find_by_status_available_correct_user, -> (current_user){ where(status: 'available', user_id: current_user.id) }
  scope :load_calendar_by_month, -> (month){ where('EXTRACT(MONTH FROM start_day) = ?', month) }

  def rental_period_is_available
    unless Calendar.where("start_day < ? && ? < end_day", end_day, start_day)
      errors.add(:start_day, "Bike is already booked in this time period")
    end
  end

end
