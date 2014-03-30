class Client < ActiveRecord::Base

  attr_accessible :name, :language, :image, :contacts_attributes
  has_attached_file :image,
  	:styles => {
  		:big => "185x185#",
  		:small => "41x41>"}
  # Se define que clases estan relacionadas con el cliente y de que manera
  has_many :contacts, :autosave => false
  has_many :projects
  validate :email_not_repeated
  validate :skype_not_repeated

  validates :name,	:presence	=>	{ :message => 'client.validates_presence_name' },
  					        :uniqueness	=>	{ :message => 'client.validates_uniqueness_name' }
  validates :language, :presence =>  { :message => 'client.validates_language' }

  accepts_nested_attributes_for :contacts

  def email_not_repeated
    if self.contacts.map(&:email).uniq.length != self.contacts.size
      errors.add(:email, 'user.validates_repeated_email')
    end
  end

  def skype_not_repeated
    if self.contacts.map(&:skype).uniq.length != self.contacts.size
      errors.add(:skype, 'user.validates_repeated_skype')
    end
  end

  def send_set_mood_contacts(id_project)
    contacts.each do |item|
      setmood = SetMood.new
      setmood.add_user(item.id)
      setmood.add_project(id_project)
      setmood.send_set_mood
      setmood.save
    end
  end

  def self.search(search,num=nil)
    if search
      where('name LIKE ?',"%#{search}%").order('name asc').limit(num)
    end
  end

  def self.send_activity_list_to_all
    Client.all.each do |cli|
      cli.contacts.all.each do |cont|
        list = (Project.all + Comment.all + Content.all + Mood.all + Milestone.all)
        list.sort_by {|x| x[:updated_at]}
        ContactMailer.send_recent_activity(cont, cli, list).deliver
      end
    end
  end

end
