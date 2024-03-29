# frozen_string_literal: true

class BookingStatusesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :payment
  before_action :logged_in_user
  before_action :user_lessor?, except: %i[create payment]
  before_action :user_renter?, only: %i[create payment]
  before_action :check_booking_status_pending?, only: %i[booking create]
  before_action :check_booking_status_booking?, only: :payment
  before_action :check_booking_status_payment?, only: :finished
  before_action :check_booking_status_pending_or_booking?, only: :cancel

  def create
    ActiveRecord::Base.transaction do
      BookingStatus.create!(booking_id: params[:booking_id], user_id: @current_user.id, status: 'cancel')
      Booking.find(params[:booking_id]).update!(status: 'cancel')
      flash[:success] = "Booking's status was updated to cancel."
      redirect_to booking_path(params[:booking_id]), status: 303
    end
  end

  def booking
    ActiveRecord::Base.transaction do
      BookingStatus.create(booking_id: params[:booking_id], user_id: @current_user.id, status: 'booking')
      Booking.find(params[:booking_id]).update(status: 'booking')
      flash[:success] = "Booking's status was updated to booking."
      redirect_to booking_path(params[:booking_id]), status: 303
    end
  end

  def cancel
    ActiveRecord::Base.transaction do
      BookingStatus.create(booking_id: params[:booking_id], user_id: @current_user.id, status: 'cancel')
      Booking.find(params[:booking_id]).update(status: 'cancel')
      flash[:success] = "Booking's status was updated to cancel."
      redirect_to booking_path(params[:booking_id]), status: 303
    end
  end

  def payment
    ActiveRecord::Base.transaction do
      BookingStatus.create(booking_id: params[:booking_id], user_id: @current_user.id, status: 'payment')
      Booking.find(params[:booking_id]).update(status: 'payment')
      flash[:success] = "Booking's status was updated to payment."
      redirect_to booking_path(params[:booking_id]), status: 303
    end
  end

  def finished
    ActiveRecord::Base.transaction do
      BookingStatus.create(booking_id: params[:booking_id], user_id: @current_user.id, status: 'finished')
      Booking.find(params[:booking_id]).update(status: 'finished')
      flash[:success] = "Booking's status was updated to finished."
      redirect_to booking_path(params[:booking_id]), status: 303
    end
  end

  private

  def check_booking_status_pending?
    redirect_to error_path unless Booking.find(params[:booking_id]).booking_statuses.last.pending?
  end

  def check_booking_status_booking?
    redirect_to error_path unless Booking.find(params[:booking_id]).booking_statuses.last.booking?
  end

  def check_booking_status_payment?
    redirect_to error_path unless Booking.find(params[:booking_id]).booking_statuses.last.payment?
  end

  def check_booking_status_pending_or_booking?
    booking = Booking.find(params[:booking_id]).booking_statuses.last
    redirect_to error_path unless booking.pending? || booking.booking?
  end
end
