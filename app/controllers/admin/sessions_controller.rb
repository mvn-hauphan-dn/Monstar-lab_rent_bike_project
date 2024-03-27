# frozen_string_literal: true

module Admin
  class SessionsController < Admin::ApplicationController
    layout 'admin_login'

    def new; end

    def create
      admin = AdminUser.find_by(email: params[:email].downcase)
      if admin&.authenticate(params[:password])
        admin_log_in admin
        params[:remember_me] == '1' ? admin_remember(admin) : admin_forget(admin)
        redirect_back_or admin_root_path
      else
        flash.now[:danger] = 'Invalid email/password combination'
        render :new, status: 422
      end
    end

    def destroy
      admin_log_out if admin_logged_in?
      redirect_to admin_login_path, status: 303
    end
  end
end
