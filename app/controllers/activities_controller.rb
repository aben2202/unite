class ActivitiesController < ApplicationController
  before_filter :activity_creator, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    #the params[:category_id] is the id of the category that was just clicked on
    # @activities = Activity.where(category_id: params[:category_id]).paginate(per_page: 5, page: params[:page])
    all_category_ids = get_all_subcategory_ids(params[:category_id]) 
    @activities = Activity.where(category_id: all_category_ids).paginate(per_page: 10, page: params[:page])
    @categories = Category.order("name").where(parent_category_id: params[:category_id])
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
    @activity = Activity.new(params[:activity])
    @activity.creator_id = current_user.id
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
    @activity = Activity.find(params[:id])
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(params[:activity])
      flash[:success] = "Activity updated"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    Activity.find(params[:id]).destroy
    flash[:success] = "Activity deleted"
    redirect_to root_path
  end

  private
    def activity_creator
      activity = Activity.find(params[:id])
      creator = User.find(activity.creator_id)
      redirect_to(root_path) unless creator == current_user
    end
end
