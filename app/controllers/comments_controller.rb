class CommentsController < ApplicationController
  def create
  	@comment = Comment.new(params[:comment])
    @activity = Activity.find(@comment.activity_id)
    @comment.user_id = current_user.id
    @comment_writer = current_user.username
    if @comment.save
      flash[:success] = "Successfully posted comment"
      redirect_to :back
      send_emails_for_new_comment
    else
      flash[:error] = "there was a problem: #{@activity.errors.full_messages}"
      redirect_to root_path
    end
  end

  def edit
  end

  def update
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to :back
  end
end
