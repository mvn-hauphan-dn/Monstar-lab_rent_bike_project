class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :load_user, only: [:show, :edit, :update]
  layout :user_layout, only: [:show, :edit]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url, status: 303
    else
      render :new, status: 422
    end
  end

  def edit
  end

  def update 
    if @user.update(update_params)
      flash[:success] = "User profile updated"
      redirect_to @user
    else
      render :edit, status: 303
    end
  end

  private

    def user_params
      params.require(:user).permit(:role, :name, :email, :password, :password_confirmation)
    end

    def load_user
      @user = User.find(params[:id])
    end

    def update_params
      params.require(:user).permit(:role, :name, :email, :password, :password_confirmation, :address, :phone_number, :avatar)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to error_path, status: 303 unless current_user?(@user)
    end
end
