class Bike < ApplicationRecord
  has_many :calendars, dependent: :destroy
  belongs_to :user
  belongs_to :category
  belongs_to :admin, optional: true
  has_many_attached :images

  enum status: [:pending, :cancel, :available]

  validates :name, presence: true, format: { with: /[a-zA-Z]+-[a-zA-Z]+-\d{4}/ }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :license_plates, presence: true, format: { with: /\d{2}-[A-Z]{1}\d{1}-\d{5}/ }

  scope :find_by_status_available_correct_user, -> (current_user){ where(status: 'available', user_id: current_user.id) }
  scope :search_by_name_or_license_plates, -> (params_search){ where('name LIKE ? OR license_plates LIKE ?', "%#{params_search}%", "%#{params_search}%") if params_search.present? }
  scope :search_by_category, -> (params_category){ where(category_id: params_category) if params_category.present? } 
  scope :search_by_status, -> (params_status){ where(status: params_status) if params_status.present? } 
end
