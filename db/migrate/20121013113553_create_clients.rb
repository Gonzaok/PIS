class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string "name", 		  :null => false
      t.string "language",  :null => false
      t.text "image",       :null => false
      t.timestamps
    end
    add_index :clients, :name, :unique => true
  end

  def self.down
    drop_table :clients
  end
end