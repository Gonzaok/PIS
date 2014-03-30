require 'spec_helper'

describe ContentsController do

	fixtures :contents, :users, :projects, :clients

	describe "#create" do
		context "Current user isn't an admin." do
			it "Current user is a contact of the client identified by id = 1 on the project identified by id = 1." do
				# Simulate current_user
				session[:user_id] = users(:contact).id
				post 'create', :content => {:summary => "Summary 3", :content => "Content 3", :user_id => contents(:one).user_id, :content_type => "Email",
												:access_moove_it => false, :access_client => false}, :project_id => contents(:one).project_id, :locale => 'en'
				response.should redirect_to project_path(Project.find(contents(:one).project_id), :tab=>'1')
			end

			it "Current user isn't a contact of the client identified by id = 1 on the project identified by id = 1." do
				# Simulate current_user
				session[:user_id] = users(:mooveit).id
				post 'create', :content => {:summary => "Summary 3", :content => "Content 3", :user_id => contents(:one).user_id, :content_type => "Email",
												:access_moove_it => false, :access_client => false}, :project_id => contents(:one).project_id, :locale => 'en'
				response.should redirect_to root_url
			end
		end

		context "Current user is an admin." do
			context "Missing attributes for content." do
				it "Fails because the content have blank summary." do
					# Simulate current_user
					session[:user_id] = users(:admin).id
					post 'create', :content => {:summary => "", :content => "Content 3", :user_id => contents(:one).user_id, :content_type => "Email",
													:access_moove_it => false, :access_client => false}, :project_id => contents(:one).project_id, :locale => 'en'
					response.should render_template 'show_add'
				end

				it "Fails because the content have blank content." do
					# Simulate current_user
					session[:user_id] = users(:admin).id
					post 'create', :content => {:summary => "Summary 3", :content => "", :user_id => contents(:one).user_id, :content_type => "Email",
													:access_moove_it => false, :access_client => false}, :project_id => contents(:one).project_id, :locale => 'en'
					response.should render_template 'show_add'
				end
			end

			context "No missing attributes for content." do
				it "Creates a new content." do
					# Simulate current_user
					session[:user_id] = users(:admin).id
					post 'create', :content => {:summary => "Summary 3", :content => "Content 3", :user_id => contents(:one).user_id, :content_type => "Email",
													:access_moove_it => false, :access_client => false}, :project_id => contents(:one).project_id, :locale => 'en'
					response.should redirect_to project_path(Project.find(contents(:one).project_id), :tab=>'1')
				end
			end
		end
	end

	describe "#update" do
		context "Missing attributes for content." do
			it 'Fails because content has empty field "summary".' do
				# Simulate current_user
	    	session[:user_id] = users(:admin).id
				post 'update', :content => {:summary => "", :content => "Content modified"}, :id_content => contents(:one).id, :locale => 'en'
				response.should render_template "contents/show_edit_errors"
			end

			it 'Fails because content has empty field "content".' do
				# Simulate current_user
	    	session[:user_id] = users(:admin).id
				post 'update', :content => {:summary => "Summary modified", :content => ""}, :id_content => contents(:one).id, :locale => 'en'
				response.should render_template "contents/show_edit_errors"
			end
		end

		context "No missing attributes for content." do
			it "Updates the content identified by id = 1." do
				# Simulate current_user
	    	session[:user_id] = users(:admin).id
				post 'update', :content => {:summary => "Summary modified", :content => "Content modified"}, :id_content => contents(:one).id, :locale => 'en'
				response.should redirect_to project_path(Project.find(contents(:one).project_id), :tab=>'1')
			end
		end
	end

	describe "#destroy" do
		it "Destroys the content identified by id = 1." do
			# Simulate current_user
	    session[:user_id] = users(:admin).id
			post 'destroy', :id => contents(:one).id, :locale => 'en'
			response.should redirect_to project_path(Project.find(contents(:one).project_id), :tab=>'1')
		end
	end

	describe "#content_ranking" do
		it "Sets new ranking for the content identified by id = 1." do
			# Simulate current_user
	    session[:user_id] = users(:admin).id
			request.env["HTTP_REFERER"] = "http://localhost:3000/en/projects/#{projects(:one).id}?tab=1"
			post 'content_ranking', :id => contents(:one).project_id, :id_content => contents(:one).id, :ranking => "4", :locale => 'en'
			response.should redirect_to :back
		end
	end

	describe "#show_all_comments" do
		it "Returns all comments." do
			# Simulate current_user
	    session[:user_id] = users(:contact).id
			post 'show_all_comments', :id => contents(:one).id, :project_id => contents(:one).project_id, :locale => 'en'
			response.should render_template "show_all_comments"
		end
	end

	describe "#modify_visibility" do
		it "Modify visibility dor content identified by id = 1." do
			# Simulate current_user
    	session[:user_id] = users(:admin).id
			request.env["HTTP_REFERER"] = "http://localhost:3000/en/projects/#{projects(:one).id}?tab=1"
			post 'modify_visibility', :id => contents(:one).id, :vis => {:access_moove_it => true, :access_client => false}, :locale => 'en'
			response.should redirect_to :back
		end
	end

end