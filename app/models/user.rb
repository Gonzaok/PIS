class User < ActiveRecord::Base

  attr_accessible :email, :name, :skype, :password, :password_confirmation, :identifier_url, :language, :en_password, :salt, :password_reset_sent_at
  attr_accessor :password

  has_many :comments
  has_many :contents
  has_many :moods

  # Regular expresion, check email format
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email,     :presence     => { :message => 'user.validates_presence_email' },
                        :format       => { :message => 'user.validates_format_email', :with => email_regex },
                        :uniqueness   => { :message => 'user.validates_uniqueness_email' }
  validates :name,      :presence     => { :message => 'user.validates_name' }
  validates :skype,		  :presence     => { :message => 'user.validates_skype' },
                        :uniqueness   => { :message => 'user.validates_uniqueness_skype' }

   validates_confirmation_of :password, :message => 'user.validates_confirmation_of_password'
  #validates :password,	:presence     => { :message => ": El Password no puede ser vacio." },
  #                      :confirmation => { :message => ": El Password no coincide con su comprobacion." },
  #                      :length       => { :message => ": El Password debe tener por lo menos 6 caracteres.",
  #                                         :within  => 6..40 }

  before_save :encrypt_password, :unless => lambda{not self.password or self.password == ""}
  after_create { send_password }

  # Return true if the user's password matches the submitted password
  def has_password?(submitted_password)
    en_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
   def send_password
    UserMailer.send_password(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  # Checks whether a given user can access a given project
  def can_access?(project_id)
    # find_by_id returns nil (~false) if there is no such project within the clients projects
    self.class != Contact || self.client.projects.where(:id => project_id).exists?
  end

  def check_not_empty
    if not self.password or self.password == ""
      errors.add(:password,'user.empty_password')
    end
  end

  private

    def encrypt_password
        self.salt = make_salt if new_record?
        self.en_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

  def self.search(search,num=nil)
    if search
      where('name LIKE ?',"%#{search}%").order('name asc').limit(num)
    end
  end

end
