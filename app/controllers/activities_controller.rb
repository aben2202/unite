class ActivitiesController < ApplicationController
  def index
    #the params[:category_id] is the id of the category that was just clicked on
    @activities = SpecificActivity.where(category_id: params[:category_id])
    
    @categories = Category.where(parent_category_id: params[:category_id])
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
