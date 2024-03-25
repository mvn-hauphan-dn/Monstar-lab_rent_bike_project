# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  def user_layout
    @current_user.renter? ? 'renter_view' : 'lessor_view'
  end

  def user_lessor?
    redirect_to error_path unless @current_user.lessor?
  end

  def user_renter?
    redirect_to error_path unless @current_user.renter?
  end
end
