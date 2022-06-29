class BookingStatus < ApplicationRecord
  belongs_to :booking
  belongs_to :user

  enum status: [:pending, :booking, :cancel, :payment, :finished]
end
