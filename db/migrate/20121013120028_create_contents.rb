class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.text    "summary",          :null     => false
      t.text    "content",          :null     => false
      t.boolean   "access_moove_it",  :default  => false
      t.boolean   "access_client",    :default  => false
      t.text    "content_type",     :null     => false
      t.integer   "ranking",          :default  => 3
      t.integer   "user_id",          :null     => false
      t.integer   "project_id",       :null     => false
      t.timestamps
    end
    add_index :contents, :user_id
    add_index :contents, :project_id
  end

  def self.down
    drop_table :contents
  end
end
