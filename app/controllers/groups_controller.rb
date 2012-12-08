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

  def invite
    debugger
    @group = Group.find(params[:group_id])
    if params[:emails] != ""
      @emails = params[:emails].split(",")
      #check for email validity
      email_format = %r([a-z0-9!#$&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)\b)
      for email in @emails do
        if email.match(email_format).nil?
          flash[:error] = "At least one email address is invalid"
          redirect_to :back and return
          break
        end
      end
      send_invite_emails(@group, @emails)
      flash[:success] = "Invites successfully sent."
      redirect_to :back
    else
      flash[:error] = "Must provide at least 1 VALID email address"
      redirect_to :back
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
    flash[:success]= "Successfully deleted group."
    redirect_to groups_path
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
