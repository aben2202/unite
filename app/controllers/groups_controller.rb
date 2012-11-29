class GroupsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_filter :group_creator, only: [:edit, :update, :destroy]

  def index
    @groups = Group.search(params[:search])
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

    group.destory
    redirect_to :back
  end

  private
    def group_creator
      group = Group.find(params[:id])
      creator = User.find(group.creator_id)
      redirect_to groups_path unless creator == current_user
    end
end
