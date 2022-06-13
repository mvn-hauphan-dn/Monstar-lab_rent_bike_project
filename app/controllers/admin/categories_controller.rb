class Admin::CategoriesController < Admin::ApplicationController
  before_action :logged_in_admin
  layout :admin_layout

  def index
    @categories = Category.page params[:page]
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Create new category successfully."
      redirect_to admin_categories_path, status: 303
    else
      render :new, status: 303
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:success] = "Category was updated"
      redirect_to admin_category_path, status: 303
    else
      render :edit, status: 303
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = "Category id = #{params[:id]} was delete"
    redirect_to admin_categories_path, status: 303
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end
end
