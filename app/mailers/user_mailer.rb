class UserMailer < ActionMailer::Base
  default from: "IT'S ON"

  def new_activity(user, activity, category, group)
    @user = user
    @activity = activity
    @category = category
    @group = group
    @creator = User.find(@activity.creator_id)

    mail to: user.email, subject: "A new activity is available for you!"
  end

  def new_comment(user, activity, comment, comment_writer)
  	@user = user
  	@activity = activity
  	@comment = comment
    @comment_writer = comment_writer

  	mail to: user.email, subject: "#{@comment_writer} posted a new comment in one of your activities"
  end

  def its_on(user, activity)
    @user = user
    @activity = activity

    mail to: user.email, subject: "The activity #{activity.title} IS ON!"
  end

  def group_invite(email, group)
    @email = email
    @group = group
    @user = User.find_by_email(@email)

    mail to: @email, subject: "You've been invited to join a private group!"
  end
end
