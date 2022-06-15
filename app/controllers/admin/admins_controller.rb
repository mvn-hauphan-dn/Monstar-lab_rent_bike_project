class Admin::AdminsController < Admin::ApplicationController
  before_action :logged_in_admin
  before_action :root_admin, except: :home
  before_action :find_admin, only: [:show, :edit, :update, :destroy]
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
  end

  def edit
  end

  def update
    if @admin.update(admin_params)
      flash[:success] = "Admin profile updated"
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
      redirect_to admin_root_path, status: 303 unless current_admin.root?
    end

    def find_admin
      @admin = Admin.find(params[:id])
    end
end
