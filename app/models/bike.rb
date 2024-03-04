# == Schema Information
#
# Table name: bikes
#
#  id             :bigint           not null, primary key
#  description    :string
#  license_plates :string
#  name           :string
#  price          :float
#  status         :integer          default("pending")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  admin_id       :bigint
#  category_id    :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_bikes_on_admin_id        (admin_id)
#  index_bikes_on_category_id     (category_id)
#  index_bikes_on_license_plates  (license_plates) UNIQUE
#  index_bikes_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (admin_id => admins.id)
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
class Bike < ApplicationRecord
  has_many :calendars, dependent: :destroy
  has_many :bookings, dependent: :destroy
  belongs_to :user
  belongs_to :category
  belongs_to :admin, optional: true
  has_many_attached :images

  enum status: [:pending, :cancel, :available]

  validates :name, presence: true, format: { with: /[a-zA-Z]+-[a-zA-Z]+-\d{4}/ }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :license_plates, presence: true, format: { with: /\d{2}-[A-Z]{1}\d{1}-\d{5}/ }, uniqueness: true

  scope :order_by_newest, -> { order(updated_at: :desc) }
  scope :find_by_status_available_correct_user, -> (current_user){ where(status: 'available', user_id: current_user.id) }
  scope :filter_by_name_or_license_plates, -> (params_filter){ where('name LIKE ? OR license_plates LIKE ?', "%#{params_filter}%", "%#{params_filter}%") if params_filter.present? }
  scope :filter_by_category, -> (params_category){ where(category_id: params_category) if params_category.present? }
  scope :filter_by_status, -> (params_status){ where(status: params_status) if params_status.present? }
  scope :filter_by_start_day_end_day, -> (start_day, end_day){ joins(:calendars).where('calendars.start_day <= ? AND calendars.end_day >= ? AND ? <= ? AND ? >= ?', start_day, end_day, start_day, end_day, start_day, Time.now) }
end
