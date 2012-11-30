class ActivitiesController < ApplicationController
  before_filter :activity_creator, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_filter :min_one_group, only: [:create, :update]

  def index
    #the params[:category_id] is the id of the category that was just clicked on
    all_category_ids = get_all_subcategory_ids(params[:category_id])

    if signed_in?
      group_ids_to_use = current_user.group_ids
    else
      group_ids_to_use = [1] #only show public activities if not signed in (0 keeps it an array)
    end 

    if Rails.env.development? #sqlite3 needs datetime manips to work
      conditions = ["groups.id IN (?) and activities.category_id IN (?) and 
                    datetime(activities.date_and_time) >= ?", group_ids_to_use, all_category_ids, Time.now ]
      order = ["datetime(activities.date_and_time)"]
    else
      conditions = ["groups.id IN (?) and activities.category_id IN (?) and
                    activities.date_and_time >= ?", group_ids_to_use, all_category_ids, Time.now ]
      order = ["activities.date_and_time"]
    end

    @activities = Activity.paginate(per_page: 10, page: params[:page]).all(joins: {:groups => :activity_group_relations}, 
                               group: 'activities.id', conditions: conditions, order: order )

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
    @category = Category.find(@activity.category_id)
    if @activity.save
      flash[:success] = "Successfully created activity: #{@activity.title}"
      redirect_to activities_path(category_id: @activity.category_id)
      send_emails_for_new_activity
    else
      flash![:error] = "there was a problem: #{@activity.errors.full_messages}"
      render 'new'
    end
  end

  def show
    @activity = Activity.find(params[:id])
    @category = Category.find(@activity.category_id)
    @creator = User.find(@activity.creator_id)
    @previous_category_id = params[:last_category_id]
    @comments = Comment.where(activity_id: @activity.id).paginate(per_page: 25, page: params[:page])
  end

  def edit
    @activity = Activity.find(params[:id])
  end

  def update
    params[:activity][:group_ids] ||= []
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(params[:activity])
      flash[:success] = "Activity updated"
      check_if_its_on(@activity)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    activity = Activity.find(params[:id])

    #destroy all participation associations for this activity
    activity.participations.each do |participation|
      participation.destroy
    end

    #destroy all activity-group-relation associations for this activity
    activity.activity_group_relations.each do |agr|
      agr.destroy
    end

    activity.destroy
    flash[:success] = "Activity deleted"
    redirect_to root_path
  end

  private
    def activity_creator
      activity = Activity.find(params[:id])
      creator = User.find(activity.creator_id)
      redirect_to(root_path) unless creator == current_user
    end

    def check_if_its_on(activity)
      if !activity.its_on? && activity.users.count >= activity.min_participants
        activity.update_attributes(its_on: true)
      elsif activity.its_on? && activity.users.count < activity.min_participants
        activity.update_attributes(its_on: false)
      end
    end

    def min_one_group
      if !params[:activity][:group_ids]
        flash[:error] = "An activity must belong to at least 1 group."
        redirect_to :back
      end
    end

end
