# spec/factories/booking_statuses.rb

FactoryBot.define do
  factory :booking_status do
    association :booking
    association :user
    status { BookingStatus.statuses.keys.sample }
  end
end
