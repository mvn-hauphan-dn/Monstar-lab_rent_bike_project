class Admin::BikesController < Admin::ApplicationController
  before_action :logged_in_admin
  layout :admin_layout

  def index
    @bikes = Bike.includes(:category).page params[:page]
  end

  def show
    @bike = Bike.find(params[:id])
  end

  def update
    @bike = Bike.find(params[:id])
    if @bike.update(status: 2, admin_id: current_admin.id)
      flash[:success] = "Bike was approved."
      redirect_to admin_bikes_path, status: 303
    else
      flash.now[:danger] = "Bike was not approved."
      render :show, status: 303
    end
  end
end
