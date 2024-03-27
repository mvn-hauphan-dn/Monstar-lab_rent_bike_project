# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url, status: 303
    else
      flash.now[:danger] = 'Email address not found'
      render :new, status: 422
    end
  end

  def edit; end

  def update
    if params[:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit, status: 422
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = 'Password has been reset.'
      redirect_to @user, status: 303
    else
      render :edit, status: 422
    end
  end

  private

  def user_params
    params.permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    return if @user&.authenticated?(:reset, params[:id])

    redirect_to root_url, status: 303
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password reset has expired.'
    redirect_to new_password_reset_url, status: 303
  end
end
