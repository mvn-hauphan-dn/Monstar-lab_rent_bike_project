# frozen_string_literal: true

# == Schema Information
#
# Table name: calendars
#
#  id         :bigint           not null, primary key
#  end_day    :date
#  start_day  :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bike_id    :bigint
#
# Indexes
#
#  index_calendars_on_bike_id  (bike_id)
#
# Foreign Keys
#
#  fk_rails_...  (bike_id => bikes.id)
#
class Calendar < ApplicationRecord
  belongs_to :bike

  validates :start_day, presence: true, comparison: { greater_than_or_equal_to: Time.now }
  validates :end_day, presence: true, comparison: { greater_than_or_equal_to: :start_day }
  validate :rental_period_is_available, on: :create

  scope :load_calendar_by_month, lambda { |month, year|
                                   where('EXTRACT(MONTH FROM start_day) = ? AND EXTRACT(YEAR FROM start_day) = ?', month, year)
                                 }

  def rental_period_is_available
    return if Calendar.where('bike_id = ? AND start_day < ? AND ? < end_day', bike_id, end_day, start_day).blank?

    errors.add(:start_day, 'Bike is already booked in this time period')
  end
end
