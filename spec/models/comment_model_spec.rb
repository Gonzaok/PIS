require 'spec_helper'

describe "#add_content" do
	fixtures :contents, :comments

	it "Sets a content to a comment." do
		comment3 = comments(:three)
		content2 = contents(:two)
		comment3.add_content(content2.id)
		comment3.content_id.should equal contents(:two).id
	end
end

describe "#add_user" do
	fixtures :comments, :users

	it "Sets a user to a comment." do
		comment3 = comments(:three)
		user1 = users(:contact)
		comment3.add_user(user1.id)
		comment3.user_id.should equal users(:contact).id
	end
end