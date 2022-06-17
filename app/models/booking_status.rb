class BookingStatus < ApplicationRecord
  belongs_to :booking

  enum status: [:pending, :booking, :cancel, :finish]
end
