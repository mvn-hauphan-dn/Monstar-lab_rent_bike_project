# frozen_string_literal: true

module Admin
  class BookingsController < Admin::ApplicationController
    before_action :logged_in_admin
    before_action :load_status, only: :index
    layout :admin_layout

    def index
      @bookings = Booking.order_by_newest.includes(:user, bike: :user).page(params[:page])
                         .filter_by_status(params[:status])
                         .filter_by_name_or_license_plates_or_user_name(params[:filter])
                         .filter_by_booking_start_day_booking_end_day(params[:start_day], params[:end_day])
    end

    def show
      @booking = Booking.find(params[:id])
    end

    private

    def load_status
      @status = Booking.statuses
    end
  end
end
