module ApplicationHelper
  def total_price booking
    if booking.booking_end_day == booking.booking_start_day
      booking.bike.price
    else
      (booking.booking_end_day - booking.booking_start_day + 1 ) * booking.bike.price
    end
  end
end
