class Content < ActiveRecord::Base

  attr_accessible :access_client, :access_moove_it, :content, :ranking, :summary, :content_type, :user_id, :project_id

  validates :summary,	:presence	=> { :message => 'content.validates_summary' }
#  validates :summary, :length => { :maximum => 180, :too_long => 'content.too_long' }
  validates :content,	:presence	=> { :message => 'content.validates_content' }

  belongs_to :user
  belongs_to :project
  has_many :comments

  before_destroy :delete_comments

  def add_user(user_id)
    user = User.find(user_id)
  	self.user = user
  	user.save
  end

  def add_project(project_id)
    project = Project.find(project_id)
    self.project = project
    project.save
  end

  def delete_comments
    self.comments.destroy_all
  end

  def self.search(search,num=nil)
    if search
      where('summary LIKE ?',"%#{search}%").order('summary asc').limit(num)
    end
  end


end
