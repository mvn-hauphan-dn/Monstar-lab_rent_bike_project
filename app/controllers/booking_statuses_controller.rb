class BookingStatusesController < ApplicationController
  def create
    BookingStatus.create(booking_id: params[:booking_id], status: 'cancel')
    flash[:success] = "Booking's status was updated to cancel."
    redirect_to booking_path(params[:booking_id]), status: 303
  end

  def booking

  end
end
