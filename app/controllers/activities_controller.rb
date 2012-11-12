class ActivitiesController < ApplicationController
  def index
    @activities = SpecificActivity.all
    @categories = Category.all
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
