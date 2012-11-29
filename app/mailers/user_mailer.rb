class UserMailer < ActionMailer::Base
  default from: "IT'S ON"

  def new_activity(user, activity, category)
    @user = user
    @activity = activity
    @category = category

    mail to: user.email, subject: "A new activity is available for you!"
  end
end
