class Category < ApplicationRecord
  has_many :bikes, dependent: :destroy

  validates :name, presence: true
end
