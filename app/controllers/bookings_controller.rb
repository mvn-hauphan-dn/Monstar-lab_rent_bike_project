class BookingsController < ApplicationController
  before_action :logged_in_user
  before_action :load_bike, only: [:new, :create]
  before_action :user_renter?, only: [:new, :create]
  layout :user_layout

  def index
    if @current_user.renter? 
      @bookings = Booking.where(user_id: current_user.id).includes(:user, bike: :user ).page(params[:page])
    else
      @bookings = Booking.joins(:bike).where(bikes: { user_id: current_user.id }).includes(:user, bike: :user).page(params[:page])
    end
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user_id = current_user.id
    if @booking.save
      BookingStatus.create(booking_id: @booking.id, user_id: @current_user.id)
      flash[:success] = "Add new booking successfully."
      redirect_to current_user, status: 303
    else
      flash.now[:danger] = "Add new booking failed."
      render :new, status: 303
    end
  end

  private

    def user_renter?
      @current_user.renter?
    end

    def load_bike
      @bikes = Bike.search_by_start_day_end_day(params[:start_day], params[:end_day]).available.includes(:category).page params[:page]
    end

    def booking_params
      params.require(:booking).permit(:bike_id, :booking_start_day, :booking_end_day)
    end
end
