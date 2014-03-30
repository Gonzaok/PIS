class CreateForms < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.string  "title",       :null => false
      t.text    "description", :null => false
      t.text    "admin_url",   :null => false
      t.text    "client_url",  :null => false
      t.string  "language",    :null => false
      t.date    "date",        :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :forms
  end
end
