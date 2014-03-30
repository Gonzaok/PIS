class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text 	  "comment",      :null => false
      t.integer "content_id"
      t.integer "mood_id"
      t.integer "user_id",      :null => false
      t.timestamps
    end
    add_index :comments, :content_id
    add_index :comments, :mood_id
    add_index :comments, :user_id
  end

  def self.down
    drop_table :comments
  end

end
