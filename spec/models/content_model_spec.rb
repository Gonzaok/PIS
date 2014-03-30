require 'spec_helper'

describe "#add_user" do
	fixtures :contents, :users

	it "Sets an user to a content." do
		content2 = contents(:two)
		user = users(:admin2)
		content2.add_user(user.id)
		content2.user_id.should equal 4
	end
end

describe "#add_project" do
	fixtures :contents, :projects

	it "Sets a project to a content." do
		content2 = contents(:two)
		project = projects(:two)
		content2.add_project(project.id)
		content2.project_id.should equal 2
	end
end

describe "#delete_comments" do
	fixtures :contents, :comments

	it "Deletes all comments of content" do
		content3 = contents(:three)
		content3.delete_comments
		content3.comments.should eq([])
	end
end