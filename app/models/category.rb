class Category < ApplicationRecord
  has_many :bikes, dependent: :destroy
end
