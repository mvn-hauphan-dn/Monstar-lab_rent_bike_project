class BikesController < ApplicationController
  before_action :logged_in_user
  before_action :load_category
  before_action :load_statuses
  layout :user_layout

  def index
    @bikes = Bike.includes(:category).page params[:page]
  end

  def show
    @bike = Bike.includes(:category, :user, :admin).find(params[:id])
  end

  def new
    @bike = Bike.new
  end

  def create
    @bike = Bike.new(bike_params)
    @bike.user_id = current_user.id
    if @bike.save
      flash[:success] = "Add new bike successfully."
      redirect_to bikes_path, status: 303
    else
      render :new, status: 303
    end
  end

  def edit
    @bike = Bike.includes(:category).find(params[:id])
  end

  def update
    @bike = Bike.find(params[:id])
    if @bike.update(bike_params)
      flash[:success] = "Bike profile updated"
      redirect_to @bike
    else
      render :edit, status: 303
    end
  end

  private

    def bike_params
      params.require(:bike).permit(:name, :price, :status, :user_id, :category_id, :description, :license_plates, images: [])
    end

    def load_category
      @categories = Category.all
    end

    def load_statuses
      @statuses = Bike.statuses.keys[1..2]
    end
end
