class Project < ActiveRecord::Base

  attr_accessor :start_date, :end_date, :client_id

  attr_accessible :name, :description, :start_date, :end_date, :client_id

  validates :name,        :presence     => { :message => 'project.validates_name' },
                          :uniqueness   => { :message => 'project.validates_uniqueness' }
  validates :description, :presence     => { :message => 'project.validates_description' }
  validates :client_id,   :presence     => { :message => 'project.validates_client' }
  validates :start_date,  :presence     => { :message => 'project.validates_start_date' }
  validates :end_date,    :presence     => { :message => 'project.validates_end_date' }
  validate :valid_date?, :on => :create


  delegate :name, :to => :client, :prefix => true

  has_many :milestones
  has_many :moods
  has_many :contents

  belongs_to :client

  before_save :add_milestones, :add_client

  before_destroy :delete_contents, :delete_moods, :delete_milestones

  def add_client
    client = Client.find(client_id)
    self.client = client
    client.save
  end

  def add_milestones
  	start_milestone = Milestone.new :date => start_date,
  									                :name => I18n.t('project.milestone_start_name'),
  									                :description => I18n.t('project.milestone_start_desc')
    self.milestones << start_milestone
  	end_milestone = Milestone.new :date => end_date,
                								  :name => I18n.t('project.milestone_end_name'),
                								  :description => I18n.t('project.milestone_end_desc')
  	self.milestones << end_milestone
  end

  def valid_date?
    if self.end_date and self.start_date
      d1 = Date.strptime(self.end_date, "%d-%m-%Y")
      d2 = Date.strptime(self.start_date, "%d-%m-%Y")
      unless ( d1 > d2 )
        errors.add(:end_date, I18n.t('project.validates_end_date_after_start_date'))
      end
    end
  end

  def delete_contents
    self.contents.destroy_all
  end

  def delete_moods
    self.moods.destroy_all
  end

  def delete_milestones
    self.milestones.destroy_all
  end

  def self.search(search,num=nil)
    if search
      where('name LIKE ?',"%#{search}%").order('name asc').limit(num)
    end
  end

  def self.send_set_mood_to_all
    Project.all.each do |item|
      if !item.filed
        last_mood = Mood.find_last_by_project_id(item.id)
        if last_mood.nil?
          item.client.send_set_mood_contacts(item.id)
        else
          if last_mood.created_at < 7.days.ago
            item.client.send_set_mood_contacts(item.id)
          end
        end
      end
    end
  end

end
