class UsersController < ApplicationController
  before_action :logged_in_user, only: :show
  before_action :correct_user, only: :show
  layout :user_layout, only: :show

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)   # Not the final implementation!
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url, status: 303
    else
      render 'new', status: 422
    end
  end

  private

    def user_params
      params.require(:user).permit(:role, :name, :email, :password,
                                  :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url, status: 303 unless current_user?(@user)
    end
end
