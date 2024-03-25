# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    binding.pry
    if user && !user.activated? && user.authenticated?(:activation, params[:token])
      user.activate
      log_in user
      flash[:success] = 'Account activated!'
      redirect_to user, status: 303
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url, status: 303
    end
  end
end
