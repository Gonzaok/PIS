class Form < ActiveRecord::Base

  attr_accessible :admin_url, :client_url, :date, :description, :language, :title

  validates :title,			:presence 	=> { :message => 'form.validates_name' }
  validates :title, :length => { :maximum => 20, :message => 'form.too_long'}
  validates :description,	:presence 	=> { :message => "form.validates_description" }
  validates :admin_url,		:presence 	=> { :message => "form.validates_admin_url_presence" },
                          :format 	=> { :message => "form.validate_url_format",
                          :with => /https:\/\/docs.google.com\/spreadsheet\/ccc\?key=\w+.*/ }
  validates :client_url,	:presence 	=> { :message => "form.validates_client_url_presence" },
                          :format 	=> { :message => "form.validate_url_format",
                          :with => /https:\/\/docs.google.com\/spreadsheet\/viewform\?(pli=\d+&)?formkey=\w+.*/ }
  belongs_to :milestone

end
