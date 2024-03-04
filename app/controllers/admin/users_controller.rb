class Admin::UsersController < Admin::ApplicationController
  before_action :logged_in_admin
  layout :admin_layout

  def index
    @users = User.filter_by_name_or_email(params[:filter]).order_by_newest.page params[:page]
  end

  def show
    @user = User.find(params[:id])
    if @user.renter?
      @bookings = Booking.where(user_id: params[:id]).page params[:page]
      render action: "renter_show"
    else
      @bikes = Bike.where(user_id: params[:id]).page params[:page]
      render action: "lessor_show"
    end
  end
end
