class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  "email"
      t.string  "name",         :null     => false
      t.string  "skype",        :null     => false
      t.boolean "is_admin",     :default  => false
      t.string  "en_password",  :null     => false
      t.string  "salt",         :null     => false
      t.string  "language",     :null     => false
      t.string  "type"
      t.integer "client_id"
      t.string  "identifier_url"
      t.timestamps
    end
    add_index :users, :email, :unique => true
    add_index :users, :client_id

    admin = MooveitUser.new :name => "Admin", :email => "admin@admin.com", :skype => "admin", :password => "admin123"
    admin[:is_admin] = true
    admin[:is_contact] = true
    admin.language = "es"
    admin.save
  end

  def self.down
    drop_table :users
  end

end
