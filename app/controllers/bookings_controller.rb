class BookingsController < ApplicationController
  before_action :logged_in_user
  before_action :load_bike, only: [:new, :create]
  layout :user_layout

  def index
    @bookings = @current_user.renter? ? Booking.where(user_id: current_user.id).page(params[:page]) : Booking.joins(:bike).where(bikes: { user_id: current_user.id }).page(params[:page])
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user_id = current_user.id
    if @booking.save
      flash[:success] = "Add new booking successfully."
      redirect_to current_user, status: 303
    else
      flash.now[:danger] = "Add new booking failed."
      render :new, status: 303
    end
  end

  private

    def load_bike
      @bikes = Bike.search_by_start_day_end_day(params[:start_day], params[:end_day]).search_by_status_available.includes(:category).page params[:page]
    end

    def booking_params
      params.require(:booking).permit(:bike_id, :booking_start_day, :booking_end_day)
    end
end
