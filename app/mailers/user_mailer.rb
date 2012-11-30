class UserMailer < ActionMailer::Base
  default from: "IT'S ON"

  def new_activity(user, activity, category, group)
    @user = user
    @activity = activity
    @category = category
    @group = group

    mail to: user.email, subject: "A new activity is available for you!"
  end

  def new_comment(user, activity, comment)
  	@user = user
  	@activity = activity
  	@comment = comment

  	mail to: user.email, subject: "#{@user.username} posted a new comment in one of your activities"
  end
end
