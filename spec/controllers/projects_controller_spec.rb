require 'spec_helper'

describe ProjectsController do
	fixtures :clients, :projects, :users

	describe "#index" do
		context "User is not a Contact" do
			it "Returns all projects." do
				# Simulate current_user
        session[:user_id] = users(:admin).id
				post 'index', :locale => "en"
				response.should render_template "index"
			end
		end
	end

	describe "#show" do
		it "Shows the project identified by id = 1." do
      # Simulate current_user
      session[:user_id] = users(:admin).id
			post 'show', :id => projects(:one).id, :locale => "en"
			response.should render_template "show"
		end
	end

	describe "#new" do
		it "Returns an empty project." do
      # Simulate current_user
      session[:user_id] = users(:admin).id
			post 'new', :locale => "en"
			response.should render_template "new"
		end
	end

	describe "#create" do
		context "Missing attributes for project." do
			it "It fails because the project doesn't have a name." do
        # Simulate current_user
        session[:user_id] = users(:admin).id
				post 'create', :project => {:description => "Description 3", :client_id => 1, start_date: "01-01-2013", end_date: "01-01-2014"}, :locale => "en"
				response.should render_template 'new'
			end

			it "It fails because the project doesn't have a description." do
        # Simulate current_user
        session[:user_id] = users(:admin).id
				post 'create', :project => {:name => "Project 3", :client_id => 1, start_date: "01-01-2013", end_date: "01-01-2014"}, :locale => "en"
				response.should render_template 'new'
			end

			it "It fails because the project doesn't have an associated client." do
        # Simulate current_user
        session[:user_id] = users(:admin).id
				post 'create', :project => {:name => "Project 3", :description => "Description 3", start_date: "01-01-2013", end_date: "01-01-2014"}, :locale => "en"
				response.should render_template 'new'
			end

			it "It fails because the project doesn't have the start date." do
        # Simulate current_user
        session[:user_id] = users(:admin).id
				post 'create', :project => {:name => "Project 3", :description => "Description 3", end_date: "01-01-2014"}, :locale => "en"
				response.should render_template 'new'
			end

			it "It fails because the project doesn't have the end date." do
        # Simulate current_user
        session[:user_id] = users(:admin).id
				post 'create', :project => {:name => "Project 3", :description => "Description 3", start_date: "01-01-2013"}, :locale => "en"
				response.should render_template 'new'
			end
		end

		context "No missing attributes for project." do
			it "It fails because already exists a project named 'Project 1'" do
        # Simulate current_user
        session[:user_id] = users(:admin).id
				post 'create', :project => {:name => "Project 1", :description => "Description 3", :client_id => 1, start_date: "01-01-2013", end_date: "01-01-2014"}, :locale => "en"
				response.should render_template 'new'
			end

			it "It fails because the project has a start date after the end date." do
        # Simulate current_user
        session[:user_id] = users(:admin).id
				post 'create', :project => {:name => "Project 3", :description => "Description 3", start_date: "01-01-2014", end_date: "01-01-2013"}, :locale => "en"
				response.should render_template 'new'
			end

			it "Creates a new project for Client 1" do
        # Simulate current_user
        session[:user_id] = users(:admin).id
				post 'create', :project => {:name => "Project 5", :description => "Description 5", :client_id => 1, start_date: "01-01-2013", end_date: "01-01-2014"}, :locale => "en"
   			response.should redirect_to "/en/projects/#{Project.last.id}"
			end
		end
	end

	describe "#destroy" do
		it "Destroys the project identified by id = 1" do
      # Simulate current_user
      session[:user_id] = users(:admin).id
			post 'destroy', :id => projects(:one).id, :locale => "en"
			response.should redirect_to '/en/projects'
		end
	end

	describe "#my_projects" do
		it "Shows the projects for client identified by id = 1" do
			# Simulate current_user
      session[:user_id] = users(:contact).id
			post 'my_projects', :locale => "en"
			response.should render_template "my_projects"
		end
	end

	describe "#file" do
		it "Archive a project." do
			# Simulate current_user
      session[:user_id] = users(:admin).id
			request.env["HTTP_REFERER"] = "http://localhost:3000/en/clients/#{projects(:one).id}"
			post 'file', :id => projects(:one).id, :locale => 'en'
			response.should redirect_to :back
		end
	end
end
