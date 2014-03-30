class CreateSetMoods < ActiveRecord::Migration
  def self.up
    create_table :set_moods do |t|
      t.string "set_mood_token"
      t.integer "user_id"
      t.integer "project_id"
      t.timestamps
    end
    add_index :set_moods, :user_id
    add_index :set_moods, :project_id
  end

  def self.down
    drop_table :set_moods
  end

end
