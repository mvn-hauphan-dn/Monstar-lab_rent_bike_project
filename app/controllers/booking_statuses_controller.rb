class BookingStatusesController < ApplicationController
  before_action :logged_in_user
  before_action :user_lessor?, except: :create
  before_action :user_renter?, only: :create
  before_action :check_booking_status_pending?, only: [:booking, :create]
  before_action :check_booking_status_booking?, only: :finished
  before_action :check_booking_status_pending_or_booking?, only: :cancel

  def create
    BookingStatus.create(booking_id: params[:booking_id], user_id: @current_user.id, status: 'cancel')
    Booking.find(params[:booking_id]).update(status: 'cancel')
    flash[:success] = "Booking's status was updated to cancel."
    redirect_to booking_path(params[:booking_id]), status: 303
  end

  def booking
    BookingStatus.create(booking_id: params[:booking_id], user_id: @current_user.id, status: 'booking')
    Booking.find(params[:booking_id]).update(status: 'booking')
    flash[:success] = "Booking's status was updated to booking."
    redirect_to booking_path(params[:booking_id]), status: 303
  end

  def cancel
    BookingStatus.create(booking_id: params[:booking_id], user_id: @current_user.id, status: 'cancel')
    Booking.find(params[:booking_id]).update(status: 'cancel')
    flash[:success] = "Booking's status was updated to cancel."
    redirect_to booking_path(params[:booking_id]), status: 303
  end

  def finished
    BookingStatus.create(booking_id: params[:booking_id], user_id: @current_user.id, status: 'finished')
    Booking.find(params[:booking_id]).update(status: 'finished')
    flash[:success] = "Booking's status was updated to finished."
    redirect_to booking_path(params[:booking_id]), status: 303
  end

  private

    def check_booking_status_pending?
      redirect_to booking_path(params[:booking_id]) unless Booking.find(params[:booking_id]).booking_statuses.last.pending?
    end

    def check_booking_status_booking?
      redirect_to booking_path(params[:booking_id]) unless Booking.find(params[:booking_id]).booking_statuses.last.booking?
    end

    def check_booking_status_pending_or_booking?
      booking = Booking.find(params[:booking_id]).booking_statuses.last
      redirect_to booking_path(params[:booking_id]) unless (booking.pending? || booking.booking?)
    end
end
