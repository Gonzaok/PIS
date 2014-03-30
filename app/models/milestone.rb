class Milestone < ActiveRecord::Base
  attr_accessible :date, :description, :name

  validates :name,			:presence => { :message => I18n.translate('milestone.validates_name') }
  validates :description,	:presence => { :message => I18n.translate('milestone.validates_description') }
  validates :date,			:presence => { :message => I18n.translate('milestone.validates_date') }
  validates_uniqueness_of :name, :scope => [:project_id]
  validate :check_date

  belongs_to :project
  has_many :forms

  def add_project(project_id)
    project = Project.find(project_id)
    self.project = project
  end

  def check_date
    if !self.date.nil?
      errors.add(:date, 'milestone.date_past') if self.date < Date.current
    end
  end

end
