class ActivitiesController < ApplicationController
  def index
    #the params[:category_id] is the id of the category that was just clicked on
    # @activities = Activity.where(category_id: params[:category_id]).paginate(per_page: 5, page: params[:page])
    @activities = category_activities(params[:category_id]).paginate(per_page: 5, page: params[:page])
    @categories = Category.where(parent_category_id: params[:category_id])
    if params[:category_id]
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
    @category = Category.find(params[:category_id])
  end

  def create
    debugger
    @activity = Activity.new(params[:activity])
    if @activity.save
      flash[:success] = "Successfully created activity: #{@activity.title}"
      redirect_to activities_path(category_id: @activity.category_id)
    else
      flash[:error] = "there was a problem: #{@activity.errors.full_messages}"
      render 'new'
    end
  end

  def show
    @activity = Activity.find(params[:id])
    @category = Category.find(@activity.category_id)
    @creator = User.find(@activity.creator_id)
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
