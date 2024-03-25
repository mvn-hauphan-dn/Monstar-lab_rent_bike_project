# frozen_string_literal: true

class BookingsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :update
  before_action :logged_in_user
  before_action :load_bike, only: %i[new create]
  before_action :user_renter?, only: %i[new create update]
  before_action :load_status, only: :index
  layout :user_layout

  def index
    if @current_user.renter?
      @bookings = Booking.order_by_newest.where(user_id: current_user.id)
                         .includes(bike: :user).page(params[:page])
                         .filter_by_status(params[:status])
                         .filter_by_name_or_license_plates_or_user_name(params[:filter])
                         .filter_by_booking_start_day_booking_end_day(params[:start_day], params[:end_day])
      render action: 'renter_index'
    else
      @bookings = Booking.joins(:bike).order_by_newest.where(bikes: { user_id: current_user.id })
                         .includes(:user, :bike).page(params[:page])
                         .filter_by_status(params[:status])
                         .filter_by_name_or_license_plates_or_user_name(params[:filter])
                         .filter_by_booking_start_day_booking_end_day(params[:start_day], params[:end_day])
      render action: 'lessor_index'
    end
  end

  def show
    if @current_user.renter?
      @booking = Booking.where(user_id: current_user.id).find(params[:id])
      render action: 'renter_show'
    else
      @booking = Booking.joins(:bike).where(bikes: { user_id: current_user.id }).find(params[:id])
      render action: 'lessor_show'
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
      flash[:success] = 'Add new booking successfully.'
      redirect_to @booking, status: 303
    else
      flash.now[:danger] = @booking.errors.full_messages.first
      render :new, status: 303
    end
  end

  def update
    @booking = Booking.where(user_id: current_user.id).find(params[:id])
    @booking.update(rating: params[:rating], comment: params[:comment])
  end

  private

  def load_bike
    return unless params[:start_day].present? && params[:end_day].present?

    @bikes = Bike.filter_by_start_day_end_day(params[:start_day],
                                              params[:end_day]).available.includes(:category).page params[:page]
  end

  def booking_params
    params.require(:booking).permit(:bike_id, :booking_start_day, :booking_end_day)
  end

  def load_status
    @status = Booking.statuses
  end
end
