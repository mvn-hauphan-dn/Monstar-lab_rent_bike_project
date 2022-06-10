class Admin::BikesController < Admin::ApplicationController
  before_action :logged_in_admin
  before_action :load_category, only: :new
  layout :admin_layout

  def index
    @bikes = Bike.includes(:category).page params[:page]
  end

  def show
    @bike = Bike.includes(:category, :user).find(params[:id])
  end

  def update
    @bike = Bike.find(params[:id])
    if @bike
      @bike.approved 
      flash.now[:success] = "Bike was approved."
      redirect_to admin_bikes_path, status: 303
    else
      flash.now[:danger] = "Bike not found."
      render :show, status: 303
    end
  end

  private

    def bike_params
      params.require(:bike).permit(:name, :price, :status, :user_id, :category_id, :license_plates, images: [])
    end

    def load_category
      @categories = Category.all
    end
end
