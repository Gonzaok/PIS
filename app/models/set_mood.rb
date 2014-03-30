class SetMood < ActiveRecord::Base
  attr_accessible :user_id, :project_id

  validates :set_mood_token, :presence => {}

  belongs_to :user
  belongs_to :project

  def add_user(id_user)
    user = User.find(id_user)
  	self.user = user
  	user.save
  end

  def add_project(id_project)
  	project = Project.find(id_project)
  	self.project = project
  	project.save
  end

  def send_set_mood
    generate_token(:set_mood_token)
    save!
    ContactMailer.send_set_mood(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while SetMood.exists?(column => self[column])
  end

  def self.clean_old_set_moods
    SetMood.all.each do |item|
      item.destroy
    end
  end

end
