class BikesController < ApplicationController
  before_action :logged_in_user
  before_action :load_category, only: :new
  layout :user_layout

  def index
    @bikes = Bike.includes(:category).page params[:page]
  end

  def show
  end

  def new
    @bike = Bike.new
  end

  def create
    @bike = Bike.new(bike_params)
    @bike.user_id = current_user.id
    if @bike.save
      flash[:success] = "Add new bike successfully."
      redirect_to current_user, status: 303
    else
      render :new, status: 303
    end
  end

  private

    def bike_params
      params.require(:bike).permit(:name, :price, :status, :category_id)
    end

    def load_category
      @categories = Category.all
    end
end
