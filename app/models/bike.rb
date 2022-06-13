class Bike < ApplicationRecord
  has_many :calendars, dependent: :destroy
  belongs_to :user
  belongs_to :category
  has_many_attached :images

  enum status: [:pending, :cancel, :available]

  validates :name, presence: true, length: { maximum: 50 }, format: { with: /[A-Z]+-[a-zA-Z]+-\d{4}/ }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :license_plates, presence: true, format: { with: /\d{2}-[A-Z]{1}\d{1}-\d{5}/ }

  scope :find_by_status_available_correct_user, -> (current_user){ where(status: 'available', user_id: current_user.id) }
end
