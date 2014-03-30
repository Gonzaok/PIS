class Comment < ActiveRecord::Base

  attr_accessor :id_content, :id_mood, :id_user

  attr_accessible :comment, :comment_type, :id_content, :id_mood, :id_user

  validates	:comment,	:presence	=>	{ :message => 'comment.error_null' }

  belongs_to :content
  belongs_to :mood
  belongs_to :user

  #before_save :add_content, :add_mood, :add_user

  def add_content(id_content)
  	content = Content.find(id_content)
  	self.content = content
  	content.save
  end

  #def add_mood(id_mood)
  #	mood = Mood.find(id_mood)
 	# self.mood = mood
  #	mood.save
  #end

  def add_user(id_user)
  	user = User.find(id_user)
  	self.user = user
  	user.save
  end

end
