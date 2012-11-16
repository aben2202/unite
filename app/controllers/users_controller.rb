class UsersController < ApplicationController

	def create
		debugger
		#add each new user to the public group
		@user = User.find(params[:user])
		@user.join_group!(1)
	end

	def show
		@user = User.find(params[:id])
	end
end