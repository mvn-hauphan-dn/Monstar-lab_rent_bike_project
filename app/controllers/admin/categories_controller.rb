# frozen_string_literal: true

module Admin
  class CategoriesController < Admin::ApplicationController
    before_action :logged_in_admin
    before_action :load_category, only: %i[show edit update destroy]
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
        flash[:success] = 'Create new category successfully.'
        redirect_to admin_categories_path, status: 303
      else
        render :new, status: 303
      end
    end

    def show; end

    def edit; end

    def update
      if @category.update(category_params)
        flash[:success] = 'Category was updated'
        redirect_to admin_category_path, status: 303
      else
        render :edit, status: 303
      end
    end

    def destroy
      @category.destroy
      flash[:success] = "Category id = #{params[:id]} was delete"
      redirect_to admin_categories_path, status: 303
    end

    private

    def load_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
  end
end
