class ParticipationsController < ApplicationController
  def create
  	@activity = Activity.find(params[:participation][:activity_id])
    current_user.participate!(@activity)
    redirect_to activity_path(@activity)
  end

  def destroy
    @activity = Participation.find(params[:id]).activity
    current_user.quit!(@activity)
    redirect_to @activity
  end
end
