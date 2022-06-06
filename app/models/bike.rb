class Bike < ApplicationRecord
  paginates_per 10
  has_many :calendars
  belongs_to :user
  belongs_to :category
  has_many_attached :images

  enum status: [:pending, :cancel, :available]

  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: true
end
