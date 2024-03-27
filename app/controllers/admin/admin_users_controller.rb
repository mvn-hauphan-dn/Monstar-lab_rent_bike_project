# frozen_string_literal: true

module Admin
  class AdminUsersController < Admin::ApplicationController
    before_action :logged_in_admin
    before_action :root_admin, except: :home
    before_action :find_admin, only: %i[show edit update destroy]
    layout :admin_layout

    def home; end

    def index
      @admins = AdminUser.filter_by_name_or_email(params[:filter]).order_by_newest.page params[:page]
    end

    def new
      @admin = AdminUser.new
    end

    def create
      @admin = AdminUser.new(admin_params)
      if @admin.save
        flash[:success] = 'Create new admin successfully.'
        redirect_to admins_path, status: 303
      else
        render :new, status: 303
      end
    end

    def show; end

    def edit; end

    def update
      if @admin.update(admin_params)
        flash[:success] = 'Admin profile updated'
        redirect_to @admin
      else
        render :edit, status: 303
      end
    end

    def destroy
      @admin.destroy
      flash[:success] = "Admin id = #{params[:id]} was delete"
      redirect_to admins_path, status: 303
    end

    private

    def admin_params
      params.require(:admin).permit(:name, :email, :password, :password_confirmation)
    end

    def root_admin
      redirect_to error_path, status: 303 unless current_admin.root?
    end

    def find_admin
      @admin = AdminUser.find(params[:id])
    end
  end
end
