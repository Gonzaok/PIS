require 'spec_helper'

describe CommentsHelper do
	fixtures :comments, :contents, :users

	describe "#comment_count" do
		it "Returns count of comments of a content." do
			comment_count(contents(:two)).should have_at_least(2).comments
		end
	end

	describe "#list_comments" do
		it "Lists a given number of comments of a given content." do
			list_comments(contents(:two), 1).should have(0).comments
		end
	end

	describe "#list_all" do
		it "Lists all comments of a given content." do
			list_all(contents(:one)).should have(2).comments
		end
	end

	describe "#check_date" do
		it "Checks if the date of the comment is valid." do
			#Simulate current_user
			session[:user_id] = users(:contact)
			check_date(comments(:one)).should be false
		end
	end
end