class UserMailer < ActionMailer::Base
  default from: "IT'S ON"

  def new_activity(user, activity, category, group)
    @user = user
    @activity = activity
    @category = category
    @group = group

    mail to: user.email, subject: "A new activity is available for you!"
  end
end
