class GroupsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_filter :group_creator, only: [:edit, :update, :destroy]

  def index
    @groups = Group.paginate(per_page: 10, page: params[:page]).search(params[:search])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    @group.creator_id = current_user.id
    if @group.save
      flash[:success] = "Successfully created group: #{@group.name}"
      redirect_to groups_path
    else
      flash[:error] = "there was a problem: #{@activity.errors.full_messages}"
      render 'new'
    end
  end

  def show
    @group = Group.find(params[:id])
    begin
      creator = User.find(@group.creator_id)
      @creator_string = creator.username
    rescue
      @creator_string = "The creator of this group is no longer a user of 'IT'S ON!'"
    end

    conditions = "groups.id = (?)", @group.id
    @members = User.paginate(per_page: 10, page: params[:page]).all(
                                                joins: { :groups => :group_memberships},
                                                conditions: conditions,
                                                group: 'users.id',
                                                order: 'users.username')
    #same conditions here
    @activities = Activity.paginate(per_page: 10, page: params[:page]).all(
                                                joins: {:groups => :activity_group_relations},
                                                conditions: conditions,
                                                group: 'activities.id',
                                                order: 'activities.date_and_time')
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      flash[:success] = "Group updated"
      redirect_to groups_path
    else
      render 'edit'
    end
  end

  def destroy
    group = Group.find(params[:id])
    
    #delete all memebership associations for this group
    group.group_memberships.each do |membership|
      membership.destroy
    end

    #delete all activity-group-relations for this group
    group.activity_group_relations.each do |agr|
      agr.destroy
    end

    group.destroy
    redirect_to :back
  end

  private
    def group_creator
      group = Group.find(params[:id])
      begin 
        creator = User.find(group.creator_id)
        redirect_to groups_path unless creator == current_user || current_user.admin?
      rescue
        redirect_to groups_path unless current_user.admin?
      end
    end
end
