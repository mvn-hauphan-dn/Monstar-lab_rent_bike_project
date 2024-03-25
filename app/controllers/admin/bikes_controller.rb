# frozen_string_literal: true

module Admin
  class BikesController < Admin::ApplicationController
    before_action :logged_in_admin
    before_action :load_category, only: :index
    before_action :load_status, only: :index
    before_action :load_booking, only: :show
    before_action :load_calendar, only: :show
    layout :admin_layout

    def index
      @bikes = Bike.order_by_newest.filter_by_name_or_license_plates(params[:filter])
                   .filter_by_category(params[:category_id])
                   .filter_by_status(params[:status])
                   .includes(:category, :user).page params[:page]
    end

    def show
      @bike = Bike.find(params[:id])
    end

    def update
      @bike = Bike.find(params[:id])
      if @bike.update(status: 2, admin_id: current_admin.id)
        flash[:success] = 'Bike was approved.'
        redirect_to admin_bikes_path, status: 303
      else
        flash.now[:danger] = 'Bike was not approved.'
        render :show, status: 303
      end
    end

    private

    def load_category
      @categories = Category.all
    end

    def load_status
      @status = Bike.statuses
    end

    def load_booking
      @bookings = Booking.where(bike_id: params[:id]).order_by_newest.includes(:user, bike: :user).page(params[:page])
    end

    def load_calendar
      @calendars = Calendar.where(bike_id: params[:id]).includes(:bike).page(params[:page])
    end
  end
end
