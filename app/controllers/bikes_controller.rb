class BikesController < ApplicationController
  before_action :logged_in_user
  layout :user_layout

  def index
    @bikes = Bike.includes(:category).page params[:page]
  end

  def show
  end

  def new
    @bike = Bike.new(category_id: 1)
  end

  def create
    @bike = Bike.new(bike_params)
    if @bike.save
      flash[:success] = "Add new bike successfully."
      redirect_to current_user, status: 303
    else
      render 'new', status: 303
    end
  end

  private

    def bike_params
      params.require(:bike).permit(:name, :price, :status,
                                  :user_id, :category_id)
    end
end
