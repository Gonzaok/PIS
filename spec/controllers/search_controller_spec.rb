require 'spec_helper'

describe SearchController do
	fixtures :users, :clients, :projects, :contents

	describe "#index" do
		context "User insn't logged." do
			it "Redirects to root url." do
				post 'index', :search => users(:contact).name, :locale => "en"
				response.should redirect_to root_url
			end
		end

		context "User is logged." do
			it "Searches users, clients and projects that matches with search criteria." do
				session[:user_id] = users(:admin).id
				post 'index', :search => users(:contact).name, :users => users(:contact), :clients => clients(:one), :projects => projects(:one), :contents => contents(:one), :locale => "en"
				response.should render_template 'index'
			end
		end
	end

	describe "#search_home" do
		context "User insn't logged." do
			it "Redirects to root url." do
				post 'search_home', :search => users(:contact).name, :locale => "en"
				response.should redirect_to root_url
			end
		end

		 context "User is logged." do
		 	it "Searches users, clients and projects that matches with search criteria." do
		 		session[:user_id] = users(:admin).id
		 		xhr :get, 'search_home', :search_focus => users(:contact).name, :locale => "en"
		 		response.should be_success
		 	end
		 end
	end
end
