class UserMailer < ActionMailer::Base
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset", :from => "Focus<focus@mooveit.com>"
  end

  def send_password(user)
    @user = user
    mail :to => user.email, :subject => I18n.t('send_password.subject'), :from => "Focus<focus@mooveit.com>"
  end
end
