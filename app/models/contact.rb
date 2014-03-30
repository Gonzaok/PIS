class Contact < User
	attr_accessible :name, :email, :skype, :language, :client_id

	# uniqueness and presence of email is already in User
	# presence of skyoe is already checked in User
	validates :language, :presence =>  { :message => 'contact.error_lenguage' }

	belongs_to :client
end
