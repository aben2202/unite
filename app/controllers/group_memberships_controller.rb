class GroupMembershipsController < ApplicationController
  def create
  	@group = Group.find(params[:group_membership][:group_id])
    current_user.join_group!(@group)
    redirect_to groups_path
  end

  def destroy
    @group = GroupMembership.find(params[:id]).group
    current_user.leave_group!(@group)
    redirect_to groups_path
  end
end
