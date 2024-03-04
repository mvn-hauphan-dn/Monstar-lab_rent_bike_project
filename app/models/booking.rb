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
class Booking < ApplicationRecord
  belongs_to :bike
  belongs_to :user
  has_many :booking_statuses

  enum status: [:pending, :booking, :cancel, :payment, :finished]

  validates :rating, numericality: { in: 1..5 }, allow_nil: true
  validates :comment, length: { maximum: 255 }
  validates :booking_start_day, presence: true, comparison: { greater_than_or_equal_to: Time.now }
  validates :booking_end_day, presence: true, comparison: { greater_than_or_equal_to: :booking_start_day }
  validate :rental_period_is_available, on: :create

  scope :order_by_newest, -> { order(updated_at: :desc) }
  scope :filter_by_name_or_license_plates_or_user_name, -> (params_filter){ joins(:bike).where('bikes.name LIKE ? OR bikes.license_plates LIKE ?', "%#{params_filter}%", "%#{params_filter}%") if params_filter.present? }
  scope :filter_by_status, -> (params_status){ where(status: params_status) if params_status.present? } 
  scope :filter_by_booking_start_day_booking_end_day, -> (start_day, end_day){ where('booking_start_day <= ? AND booking_end_day >= ? AND ? <= ? AND ? >= ?', start_day, end_day, start_day, end_day, start_day, Time.now) if (start_day.present? && end_day.present?) }

  def rental_period_is_available
    return if Booking.where("bike_id = ? AND booking_start_day <= ? AND ? <= booking_end_day", bike_id, booking_end_day, booking_start_day).blank?

    errors.add(:booking_start_day, "is already booked in this time period")
  end
end
