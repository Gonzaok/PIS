require 'spec_helper'

describe CommentsController do
	fixtures :comments, :users, :contents, :projects

	describe "#create" do
		context "Missing attributes for comment." do
			it 'Fails because "comment" field is empty.' do
				# Simulate current_user
        session[:user_id] = users(:admin).id
				post 'create', :comment => {:comment => ""}, :id => comments(:one).content_id, :locale => 'en'
				response.should redirect_to "/en/projects/1?tab=1"
			end
		end

		context "No missing attributes for comment." do
			it 'Creates a new comment for content identified by id = 1' do
				# Simulate current_user
        session[:user_id] = users(:admin).id
				post 'create', :comment => {:comment => "This is a comment"}, :id => comments(:one).content_id, :locale => 'en'
				response.should redirect_to "/en/projects/1?tab=1"
			end
		end
	end

	describe "#update" do
		context "Missing attributes for comment." do
			it 'Fails because "comment" field is empty.' do
				# Simulate current_user
        session[:user_id] = users(:admin).id
				post 'update', :comment => "", :id => comments(:one).content_id, :locale => 'en'
				response.should render_template "edit"
			end
		end

		context "No missing attributes for comment." do
			it 'Updates a comment for content identified by id = 1' do
				# Simulate current_user
        session[:user_id] = users(:admin).id
				post 'update', :comment => {:comment => "This also is a comment"}, :id => comments(:one).content_id, :locale => 'en'
				response.should redirect_to "/en/projects/1?tab=1"
			end
		end
	end

	describe "#destroy" do
		context "Can't destroy the comment." do
			it "Fails because user isn't an admin or the user who created the comment." do
				# Simulate current_user
        session[:user_id] = users(:contact).id
				post 'destroy', :id => comments(:two).id, :locale => 'en'
				response.should render_template 200
			end
		end

		context "Destroys the comment." do
			it "User is an admin but isn't the user who created the comment." do
				# Simulate current_user
        session[:user_id] = users(:admin).id
				post 'destroy', :id => comments(:two).id, :locale => 'en'
				response.should render_template 200
			end

			it "User isn't an admin but is the user who created the comment." do
				# Simulate current_user
        session[:user_id] = users(:mooveit).id
				post 'destroy', :id => comments(:two).id, :locale => 'en'
				response.should render_template 200
			end
		end
	end
end
