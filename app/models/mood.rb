class Mood < ActiveRecord::Base
  attr_accessible :mood, :comment, :user_id, :project_id

  validates :mood, :presence => {}

  belongs_to :user
  belongs_to :project

  HAPPY=4
  SATISFIED=3
  NEUTRAL=2
  SAD=1
  ANGRY=0
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

  def mood_number
    case mood
    when 'Happy'
      return HAPPY
    when 'Satisfied'
      return SATISFIED
    when 'Neutral'
      return NEUTRAL
    when 'Sad'
      return SAD
    else
      return ANGRY
    end
  end

end
