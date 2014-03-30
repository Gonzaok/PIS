require 'spec_helper'

describe MilestonesController do
	fixtures :projects, :milestones, :users

	before(:each) do
		session[:user_id] = users(:admin).id
	end

	describe "#edit" do
		it "Returns the milestone identified by id = 1" do
			post 'edit', :id => milestones(:one).id, :locale => 'en'
			response.should render_template "edit"
		end
	end

	describe "#create" do
		context "Missing attributes for milestone." do
			it "It fails because the milestone doesn't have a name." do
				post 'create', :milestone => {:description => "Description 3", date: "01-01-2013"}, :project_id => projects(:one).id, :locale => "en"
				response.should redirect_to "/en/projects/#{projects(:one).id}?tab=2"
			end

			it "It fails because the milestone doesn't have a description." do
				post 'create', :milestone => {:name => "Milestone 3", date: "01-01-2013"}, :project_id => projects(:one).id, :locale => "en"
				response.should redirect_to "/en/projects/#{projects(:one).id}?tab=2"
			end

			it "It fails because the milestone doesn't have a date." do
				post 'create', :milestone => {:name => "Milestone 3", :description => "Description 3"}, :project_id => projects(:one).id, :locale => "en"
				response.should redirect_to "/en/projects/#{projects(:one).id}?tab=2"
			end
		end

		context "No missing attributes for milestone." do
			it "Creates a new milestone for Project 1" do
				post 'create', :milestone => {:name => "Milestone 3", :description => "Description 3", date: "01-01-2013"}, :project_id => projects(:one).id, :locale => "en"
				response.should redirect_to "/en/projects/#{projects(:one).id}?tab=2"
			end
		end
	end

	describe "#update" do
		context "Missing attributes for milestone." do
			it "Trying to update the milestone identified by id = 1 with a blank name." do
				request.env["HTTP_REFERER"] = "http://localhost/en/projects/#{projects(:one).id}?tab=2"
				post 'update', :milestone => {:name => ""}, :id => milestones(:one).id, :project_id => projects(:one).id, :locale => "en"
				response.should redirect_to :back
			end

			it "Trying to update the milestone identified by id = 1 with a blank description." do
				request.env["HTTP_REFERER"] = "http://localhost/en/projects/#{projects(:one).id}?tab=2"
				post 'update', :milestone => {:description => ""}, :id => milestones(:one).id, :project_id => projects(:one).id, :locale => "en"
				response.should redirect_to :back
			end

			it "Trying to update the milestone identified by id = 1 with a blank date." do
				request.env["HTTP_REFERER"] = "http://localhost/en/projects/#{projects(:one).id}?tab=2"
				post 'update', :milestone => {:date => ""}, :id => milestones(:one).id, :project_id => projects(:one).id, :locale => "en"
				response.should redirect_to :back
			end
		end

		context "No missing attributes for milestone." do
			it "Updates the milestone identified by id = 1" do
				post 'update', :milestone => {:name => "Milestone 3", :description => "Description 3", date: "01-01-2013"}, :id => milestones(:one).id, :project_id => projects(:one).id, :locale => "en"
				response.should redirect_to '/en/projects/1?tab=2'
			end
		end
	end

	describe "#destroy" do
		it "Destroys the milestone identified by id = 1" do
			post 'destroy', :id => milestones(:one).id, :locale => "en"
			response.should redirect_to '/en/projects/1?tab=2'
		end
	end
end
