require 'spec_helper'

describe ProjectsHelper do
	fixtures :projects, :moods, :contents, :users

	describe "#show_mood" do
		context "Project doesn't has a mood." do
			it 'Shows a happy face ("initial mood")' do
				show_mood(projects(:four)).should include "happy.png"
			end
		end

		context "Project already has a mood." do
			it "Shows the last mood for a project" do
				show_mood(projects(:one)).should include "sad.png"
			end
		end
	end

	describe "#show_comment_mood" do
		it "Shows the last comment of the mood." do
			show_comment_mood(projects(:one)).should include "Comment 7"
		end
	end

	describe "#contents" do
		it "Returns all contents of a project (depends the type of user that logged in)." do
			# Simulate current_user
    	session[:user_id] = users(:contact).id
    	result = contents(projects(:one))
    	result.should have(2).things
    end
  end

  describe "#show_chart" do
		it 'Renders the partial view "charts".' do
			@project = projects(:one)
			show_chart.should include "<script"
    end
  end

  describe "#show_moods" do
		it 'Show normal happy face.' do
			show_moods(projects(:one)).should include 'happy.png'
		end

		it "Show large sad face." do
			show_moods(projects(:two)).should include 'sad-lrg.png'
		end

		it "Show small satisfied face." do
			show_moods(projects(:three)).should include 'satisfied-sml.png'
    end
  end
end