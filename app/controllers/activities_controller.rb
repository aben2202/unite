class ActivitiesController < ApplicationController
  def index
    #the params[:category_id] is the id of the category that was just clicked on
    @activities = Activity.where(category_id: params[:category_id])
    @categories = Category.where(parent_category_id: params[:category_id])
    if params[:category_id]
      # debugger
      @current_directory = Category.find(params[:category_id])
      parent_directory_id = @current_directory.parent_category_id
      if parent_directory_id
        @parent_directory = Category.find(parent_directory_id)
      else
        @parent_directory = nil
      end
    end
  end

  def new
    @activity = Activity.new
  end

  def create
    @new_activity = Activity.new(params[:activity])
    if @new_activity.save
      flash[:success] = "Successfully created activity: #{@new_activity.name}"
      redirect_to activities_path
    else
      flash[:error] = "there was a problem"
    end
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
