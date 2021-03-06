class UsersController < ApplicationController

	def create
		#add each new user to the public group
		@user = User.find(params[:user])
		@user.join_group!(1)
	end

	def index
		@users = User.all(order: 'users.username')
	end

	def show
		@user = User.find(params[:id])
		@section = params[:section]

		if Rails.env.development? #sqlite3 needs datetime manips
			conditions = ["participations.user_id = ? and DATE(activities.date_and_time) >= DATE(?)", @user.id, Time.now]
			order = ["datetime(activities.date_and_time)"]
		else
			conditions = ["participations.user_id = ? and activities.date_and_time >= ?", @user.id, Time.now]
			order = ["activities.date_and_time"]
		end

		@upcoming_activities = Activity.paginate(per_page: 10, page: params[:page]).all(
				joins: { :participations => { } }, conditions: conditions, order: order )
	end

	def groups
		@title = "Groups"
		@user = User.find(params[:id])
		@section = "groups"
		render "show_user_section"
	end

	def subscriptions
		@title = "Subscriptions"
		@user = User.find(params[:id])
		@section = "subscriptions"
		render "show_user_section"
	end

	def activities
		@title = "Upcoming Activities"
		@user = User.find(params[:id])
		@section = "activities"

		# if Rails.env.development? #sqlite3 needs datetime manips
		# 	conditions = ["participations.user_id = ? and DATE(activities.date_and_time) >= DATE(?)", @user.id, Time.now]
		# 	order = ["datetime(activities.date_and_time)"]
		# else
			conditions = ["participations.user_id = ? and activities.date_and_time >= ?", @user.id, Time.now]
			order = ["activities.date_and_time"]
		# end

		@upcoming_activities = Activity.paginate(per_page: 5, page: params[:page]).all(
				joins: { :participations => { } }, conditions: conditions, order: order )
		render "show_user_section"
	end

	def general_info
		@title = "General Info"
		@user = User.find(params[:id])
		@section = "general_info"
		render "show_user_section"
	end

	def notifications
		@title = "Notifications"
		@user = User.find(params[:id])
		@section = "notifications"
		render "show_user_section"
	end

	def invites
		debugger
		if signed_in? && params[:id].to_i == current_user.id
			@title = "Invites"
			@user = User.find(params[:id])
			@section = "invitations"
			render "show_user_section"
		else
			redirect_to root_path
		end
	end

	def invite_reply
		debugger
		@invite = Invite.find(params[:invite_id])
		@response = params[:response]

		guest = User.find_by_email(@invite.guest_email)
	    if signed_in? and current_user == guest
	      if @response == "accept"
	        group = Group.find(@invite.group_id)
	        current_user.join_group!(group)
	        @invite.update_attributes(response: 1)
	        flash[:success] = "Successfully added group."
	      elsif @response == "deny"
	        @invite.update_attributes(response: 0)
	        flash[:success] = "Successfuly denied invitation."
	      end
	      redirect_to :back
	  	end
    end


	def update
		@user = User.find(params[:id])
		@user.update_attributes(params[:user])
		if @user.save
			flash[:success] = "Successfully updated user"
			sign_in @user
			redirect_to :back
		else
			flash[:error] = "There was a problem: #{@user.errors.full_messages}"
			redirect_to :back
		end
	end

	def destroy
		user = User.find(params[:id])

		#destroy user subscriptions associations
		user.subscriptions.each do |sub|
			sub.destroy
		end

		#destroy user participations associations
		user.participations.each do |par|
			par.destroy
		end

		#destroy user group membership associations
		user.group_memberships.each do |mem|
			mem.destroy
		end

		user.destroy
		flash[:success] = "Your account has successfully been deleted."
		redirect_to root_path
	end
end