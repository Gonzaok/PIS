class CreateMoods < ActiveRecord::Migration
  def self.up
    create_table :moods do |t|
      t.string "mood"
      t.string "comment"
      t.integer "user_id"
      t.integer "project_id"
      t.timestamps
    end
    add_index :moods, :user_id
    add_index :moods, :project_id
  end

  def self.down
    drop_table :moods
  end
end
