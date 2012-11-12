class CategoriesController < ApplicationController
before_filter :admin_user, only: [:new, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @new_category = Category.new(params[:category])
    if @new_category.save
      flash[:success] = "Successfully created category: #{@new_category.name}"
    else
      flash[:error] = "there was a problem"
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
    if @category.update_attributes(params[:category])
      flash[:success] = "Successfully updated category: #{@category.name}"
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = "Category removed"
    redirect_to root
  end

  private

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
