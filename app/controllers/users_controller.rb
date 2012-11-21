class UsersController < ApplicationController

	def create
		#add each new user to the public group
		@user = User.find(params[:user])
		@user.join_group!(1)
	end

	def show
		@user = User.find(params[:id])
		@upcoming_activities = Activity.paginate(per_page: 5, page: params[:page]).all(
				joins: { :participations => { } }, 
				conditions: ["participations.user_id = ? and DATE(activities.date_and_time) >= DATE(?)", 
								@user.id, Time.now],
				order: ["datetime(activities.date_and_time)"] )
	end

	def update
		@user = User.find(params[:id])
		@user.update_attributes(params[:user])
		if @user.save
			flash[:success] = "Successfully updated user"
			sign_in @user
			redirect_to @user
		else
			flash[:error] = "There was a problem: #{@user.errors.full_messages}"
			render 'show'
		end
	end
end