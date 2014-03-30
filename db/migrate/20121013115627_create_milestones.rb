class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
   	  t.string  "name", 		      :null => false
      t.text    "description",    :null => false
      t.integer "project_id",     :null => false
      t.date    "date",           :null => false
      t.timestamps
    end
    add_index :milestones, :project_id
  end

  def self.down
    drop_table :milestones
  end
end
