# frozen_string_literal: true

class BikesController < ApplicationController
  before_action :logged_in_user
  before_action :load_category, except: %i[show cancel]
  before_action :load_status, only: :index
  before_action :available_bike, only: %i[edit update]
  before_action :correct_bike, only: %i[show cancel]
  before_action :user_lessor?, only: %i[new create index]
  layout :user_layout

  def index
    @bikes = Bike.order_by_newest.where(user_id: current_user.id)
                 .filter_by_name_or_license_plates(params[:filter])
                 .filter_by_category(params[:category_id])
                 .filter_by_status(params[:status])
                 .includes(:category).page params[:page]
  end

  def show; end

  def new
    @bike = Bike.new
  end

  def create
    @bike = Bike.new(bike_params)
    @bike.user_id = current_user.id
    if @bike.save
      flash[:success] = 'Add new bike successfully.'
      redirect_to bikes_path, status: 303
    else
      render :new, status: 303
    end
  end

  def edit; end

  def update
    if @bike.update(update_params)
      flash[:success] = 'Bike profile updated'
      redirect_to @bike
    else
      render :edit, status: 303
    end
  end

  def cancel
    if @bike.cancel!
      flash[:success] = 'Bike was cancel.'
      redirect_to bike_path, status: 303
    else
      flash.now[:danger] = 'Bike can not cancel.'
      render :show, status: 303
    end
  end

  private

  def bike_params
    params.require(:bike).permit(:name, :category_id, :price, :description, :license_plates, images: [])
  end

  def update_params
    params.require(:bike).permit(:description, images: [])
  end

  def load_category
    @categories = Category.all
  end

  def load_status
    @status = Bike.statuses
  end

  def correct_bike
    @bike = Bike.where(user_id: current_user.id).find(params[:id])
  end

  def available_bike
    @bike = Bike.where(user_id: current_user.id, status: 2).find(params[:id])
  end
end
