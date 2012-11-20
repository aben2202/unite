class CommentsController < ApplicationController
  def create
  	@comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = "Successfully posted comment"
      redirect_to :back
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
