class UsersController < ApplicationController

	def create
		#add each new user to the public group
		@user = User.find(params[:user])
		@user.join_group!(1)
	end

	def show
		@user = User.find(params[:id])
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