class Notifier < ActionMailer::Base
#  default from: "from@example.com"

  def send_form(project,contact,subj,message,link)
    mail(:to => contact.email, :subject => subj, :from => "Focus Notifications<focus@mooveit.com>" ) do |format|
      @project = project
      @contact = contact
      @message = message
      @url = link.gsub(/#gid=0/,'') + "&entry_0=#{project.id}"
      format.html
    end
  end

end
