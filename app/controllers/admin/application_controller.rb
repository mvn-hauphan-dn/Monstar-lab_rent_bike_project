# frozen_string_literal: true

module Admin
  class ApplicationController < ActionController::Base
    include Admin::SessionsHelper

    private

    def logged_in_admin
      return if admin_logged_in?

      store_location
      flash[:danger] = 'Please log in.'
      redirect_to admin_login_url
    end

    def admin_layout
      @current_admin.root? ? 'root_view' : 'admin_view'
    end
  end
end
