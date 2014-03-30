require 'spec_helper'

describe "#send_activity_list_to_all" do
	fixtures :projects, :comments, :contents, :moods, :milestones, :clients

	it "Sends activity list to all contacts of each client." do
		Client.send_activity_list_to_all.should have_at_least(1).content
	end
end