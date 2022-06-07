class Bike < ApplicationRecord
  has_many :calendars, dependent: :destroy
  belongs_to :user
  belongs_to :category
  has_many_attached :images

  enum status: [:pending, :cancel, :available]

  validates :name, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
