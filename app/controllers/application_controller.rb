class ApplicationController < ActionController::Base
  include SessionsHelper

  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def user_layout
      @current_user.role == "renter" ? "renter_view" : "lessor_view"
    end
end
