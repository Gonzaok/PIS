class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string  "name", 		  :null => false
      t.text    "description"
      t.integer "client_id"
      t.boolean "filed", :default => false
      t.timestamps
    end
    add_index :projects, :name, :unique => true
    add_index :projects, :client_id
  end

  def self.down
    drop_table :projects
  end
end
