require 'spec_helper'

describe "#send_set_mood_to_all" do
	fixtures :projects, :moods, :clients

	it "Creates a 'Set_mood' for each client of each project." do
		mood = Mood.find_last_by_project_id(projects(:one))
		mood.created_at = 8.days.ago
		mood.save
		Project.send_set_mood_to_all.should have_at_least(1).thing
	end
end