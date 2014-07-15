class UserMailer < ActionMailer::Base
  default from: "peter@burn-notice.me"

  def signup(user)
    @user = user

    mail to: user.email, subject: 'Validate your E-Mail!'
  end
end
