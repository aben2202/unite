class UsersController < ApplicationController

	def create
		#add each new user to the public group
		@user = User.find(params[:user])
		@user.join_group!(1)
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

		@upcoming_activities = Activity.paginate(per_page: 5, page: params[:page]).all(
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

		if Rails.env.development? #sqlite3 needs datetime manips
			conditions = ["participations.user_id = ? and DATE(activities.date_and_time) >= DATE(?)", @user.id, Time.now]
			order = ["datetime(activities.date_and_time)"]
		else
			conditions = ["participations.user_id = ? and activities.date_and_time >= ?", @user.id, Time.now]
			order = ["activities.date_and_time"]
		end

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
		@title = "notifications"
		@user = User.find(params[:id])
		@section = "notifications"
		render "show_user_section"
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
		redirect_to :back
	end
end