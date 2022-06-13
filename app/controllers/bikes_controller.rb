class BikesController < ApplicationController
  before_action :logged_in_user
  before_action :load_category, only: [:new, :edit]
  before_action :available_bike, only: [:edit, :update, :show]
  layout :user_layout

  def index
    @bikes = Bike.where(user_id: current_user.id).includes(:category).page params[:page]
  end

  def show
  end

  def new
    @bike = Bike.new
  end

  def create
    @bike = Bike.new(bike_params)
    @bike.user_id = current_user.id
    @bike.status = 'pending'
    if @bike.save
      flash[:success] = "Add new bike successfully."
      redirect_to bikes_path, status: 303
    else
      render :new, status: 303
    end
  end

  def edit
  end

  def update
    if @bike.update(update_params)
      flash[:success] = "Bike profile updated"
      redirect_to @bike
    else
      render :edit, status: 303
    end
  end

  private

    def bike_params
      params.require(:bike).permit(:name, :price, :description, :license_plates, images: [])
    end

    def update_params
      params.require(:bike).permit(:description, images: [])
    end

    def load_category
      @categories = Category.all
    end

    def available_bike
      @bike = Bike.where(user_id: current_user.id).find(params[:id])
      redirect_to @bike, status: 303 unless @bike.available?
    end
end
