class Admin::AdminsController < Admin::ApplicationController
  before_action :logged_in_admin
  before_action :root_admin, except: [:home]
  layout :admin_layout

  def home
  end

  def index
    @admins = Admin.page params[:page]
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      flash[:success] = "Create new admin successfully."
      redirect_to admins_path, status: 303
    else
      render :new, status: 303
    end
  end

  def show
    @admin = Admin.find(params[:id])
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    @admin = Admin.find(params[:id])
    if @admin.update(admin_params)
      flash[:success] = "Admin profile updated"
      redirect_to @admin
    else
      render :edit, status: 303
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    if @admin.destroy
      flash[:success] = "Admin id = #{params[:id]} was delete"
      redirect_to admins_path, status: 303
    else
      render admins_path, status: 303
    end
  end

  private

    def admin_params
      params.require(:admin).permit(:name, :email, :password, :password_confirmation)
    end

    def root_admin
      redirect_to admins_url, status: 303 unless current_admin.root?
    end
end
