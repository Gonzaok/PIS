class ContactMailer < ActionMailer::Base
  add_template_helper(UsersHelper)

  default from: "Focus<focus@mooveit.com>"

  def send_set_mood(setmood)
  	@setmood = setmood
  	@contact = setmood.user
  	mail(:to => @contact.email, :subject => @contact.name + ", " + I18n.t('set_mood.how_are'))
  end

  def send_recent_activity(cont, cli, list)
  	@list = list
  	@cli = cli
  	@contact = cont
  	mail(:to => @contact.email, :subject => I18n.t('recent_activity.recent_act_mail_subject'))
  end

end