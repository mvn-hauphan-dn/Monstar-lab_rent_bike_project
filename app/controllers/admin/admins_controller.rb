class Admin::AdminsController < Admin::ApplicationController
  before_action :logged_in_admin
  before_action :correct_admin, only: :show
  layout :admin_layout, only: [:home, :show]

  def home
  end

  def show
  end

  private

    def correct_admin
      @admin = Admin.find(params[:id])
      redirect_to admin_login_path, status: 303 unless current_admin?(@admin)
    end
end
