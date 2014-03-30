require 'spec_helper'

describe UsersController do
	fixtures :users, :clients

	before(:each) do
		session[:user_id] = users(:admin).id
	end

	describe "#index." do
		it "Returns all users with type 'MooveitUser'." do
			post 'index', :locale => 'en'
			response.should render_template "index"
		end
	end

	describe "#show." do
		it "Shows the user identified by id = 1." do
			post 'show', :id => 1, :locale => "en"
			response.should render_template "show"
		end
	end

	describe "#toggle_admin." do
    it "Toggles administrative permissions for user identified by id = 1." do
	    post 'toggle_admin', :id => 1, :locale => "en"
	    response.should redirect_to users_url
	  end
  end

	describe "#edit_profile." do
		it "Returns the user identified by id = 1." do
			post 'edit_profile', :id => 1, :locale => 'en'
			response.should render_template "edit_profile"
		end
	end

	describe "#edit_contact." do
		it "Returns the user identified by id = 1." do
			post 'edit_contact', :id => 1, :locale => 'en'
			response.should render_template "edit_contact"
		end
	end

	describe "#create." do
		context "Missing attributes for user." do
			it "It fails because the user doesn't have a name." do
				request.env["HTTP_REFERER"] = "http://localhost:3000/"
				post 'create', :user => {:email => "user3@user.com", :skype => "skype 3"}, :locale => "en"
				response.should redirect_to :back
			end

			it "It fails because the user doesn't have an email." do
				request.env["HTTP_REFERER"] = "http://localhost:3000/"
				post 'create', :user => {:name => "User 3", :skype => "skype 3"}, :locale => "en"
				response.should redirect_to :back
			end

			it "It fails because the user doesn't have a skype." do
				request.env["HTTP_REFERER"] = "http://localhost:3000/"
				post 'create', :user => {:name => "User 3", :email => "user3@user.com"}, :locale => "en"
				response.should redirect_to :back
			end
		end

		context "No missing attributes for user." do
			it "It fails because 'email' format is incorrect" do
				request.env["HTTP_REFERER"] = "http://localhost:3000/"
				post 'create', :user => {:name => "User 3", :email => "user3", :skype => "skype 3", :language => "English", :en_password => "user3"}, :locale => "en"
				response.should redirect_to :back
			end

			it "It fails because 'email' is already assigned for another user." do
				request.env["HTTP_REFERER"] = "http://localhost:3000/"
				post 'create', :user => {:name => "User 3", :email => users(:contact).email, :skype => "skype 3", :language => "English", :en_password => "user3"}, :locale => "en"
				response.should redirect_to :back
			end

			it "Creates a new user named 'User 3'" do
				request.env["HTTP_REFERER"] = "http://localhost:3000/"
				post 'create', :user => {:name => "User 3", :email => "user3@user.com", :skype => "skype 3", :language => "English", :en_password => "user3", :salt => "jdjd"}, :locale => "en"
				response.should redirect_to "/en/users"
			end
		end
	end

	describe '#new_contact.' do
		it "Returns a new contact." do
			post 'new_contact', :user => {:name => "Contact 2", :email => "con2@cli1.com", :skype => "skype contact 2"}, :locale => 'en', :id => 1
			response.should render_template "new_contact"
		end
	end

	describe "#create_contact." do
		context "Missing attributes for user" do
			it "It fails because the user doesn't have a language." do
				post 'create_contact', :contact => {:name => "Contacto 2", :email => "con2@cli1.com", :skype => "skype contact 2", :client_id => 1}, :locale => 'en'
				response.should render_template "new_contact"
			end
		end

		context "No missing attributes for user." do
			it "Creates a contact for Client identified by id = 1." do
				post 'create_contact', :contact => {:name => "Contacto 2", :email => "con2@cli1.com", :skype => "skype contact 2", :language => "English", :client_id => 1, :en_password => "client1", :salt => "client1"}, :locale => 'en'
				response.should redirect_to "/en/clients/1"
			end
		end
	end

	describe "#update_profile." do
		context "User's type is 'MooveitUser'." do
			before(:each) do
				session[:user_id] = users(:mooveit).id
			end
			context "User want to change password." do
				context "Problems with passwords." do
					it "Fails because current password is incorrect." do
						post 'update_profile', :mooveit_user => {:password => "contact1", :current_password => "I'm a contact", :password_confirmation => "contact1"}, :locale => 'en'
						response.should redirect_to "/en/users/edit_profile"
					end

					it "Fails because 'password' and 'password_confirmation' fields doesn't match." do
						post 'update_profile', :mooveit_user => {:password => "contact1", :current_password => "Contacto 1", :password_confirmation => "contact2"}, :locale => 'en'
						response.should render_template "edit_profile"
					end

					it "Fails because 'password' field is empty." do
						post 'update_profile', :mooveit_user => {:password => "", :current_password => "Contacto 1", :password_confirmation => ""}, :locale => 'en'
						response.should render_template "edit_profile"
					end
				end

				context "No problems with passwords." do
					it "The password of user identified by id = 2 is modified." do
						post 'update_profile', :mooveit_user => {:password => "contact2", :current_password => "Contacto 1", :password_confirmation => "contact2"}, :locale => 'en'
						response.should redirect_to "/en/users/edit_profile"
					end
				end
			end

			context "User doesn't want to change password." do
				context "Missing attributes for user." do
					it "Trying to update the user identified by id = 2 with a blank name." do
						post 'update_profile', :mooveit_user => {:name => "", :password => "", :password_confirmation => "", :current_password => ""}, :locale => 'en'
						response.should render_template "edit_profile"
					end

					it "Trying to update the user identified by id = 2 with a blank email." do
						post 'update_profile', :mooveit_user => {:email => "", :password => "", :password_confirmation => "", :current_password => ""}, :locale => 'en'
						response.should render_template "edit_profile"
					end

					it "Trying to update the user identified by id = 2 with a blank skype." do
						post 'update_profile', :mooveit_user => {:skype => "", :password => "", :password_confirmation => "", :current_password => ""}, :locale => 'en'
						response.should render_template "edit_profile"
					end
				end

				context "No missing attributes for user." do
					it "It fails because 'email' format is incorrect" do
						post 'update_profile', :mooveit_user => {:email => "moo3", :password => "", :password_confirmation => "", :current_password => ""}, :locale => "en"
						response.should render_template "edit_profile"
					end

					it "It fails because 'email' is already assigned for another user." do
						post 'update_profile', :mooveit_user => {:email => users(:admin).email, :password => "", :password_confirmation => "", :current_password => ""}, :locale => "en"
						response.should render_template "edit_profile"
					end

					it "Updates fields for user identified by id = 2" do
						post 'update_profile', :mooveit_user => {:name => "Mooveit 3", :email => "moo3@mooveit.com", :skype => "skype 3", :password => "", :password_confirmation => "", :current_password => ""}, :locale => "en"
						response.should redirect_to "/en/users/edit_profile"
					end
				end
			end
		end

		context "User's type is 'Contact'." do
			before(:each) do
				session[:user_id] = users(:contact).id
			end
			context "User want to change password." do
				context "Problems with passwords." do
					it "Fails because current password is incorrect." do
						post 'update_profile', :contact => {:password => "contact1", :current_password => "I'm a contact", :password_confirmation => "contact1"}, :locale => 'en'
						response.should redirect_to "/en/users/edit_profile"
					end

					it "Fails because 'password' and 'password_confirmation' fields doesn't match." do
						post 'update_profile', :contact => {:password => "contact1", :current_password => "Contacto 1", :password_confirmation => "contact2"}, :locale => 'en'
						response.should render_template "edit_profile"
					end

					it "Fails because 'password' field is empty." do
						post 'update_profile', :contact	=> {:password => "", :current_password => "Contacto 1", :password_confirmation => ""}, :locale => 'en'
						response.should render_template "edit_profile"
					end
				end

				context "No problems with passwords." do
					it "It fails because 'skype' is already assigned for another user." do
						post 'update_profile', :contact => {:name => users(:contact).name, :skype => users(:admin).skype, :language => users(:contact).language[0,2].downcase, :password => "contact2", :current_password => "Contacto 1", :password_confirmation => "contact2"}, :locale => 'en'
						response.should render_template "edit_profile"
					end

					it "The password of user identified by id = 2 is modified." do
						post 'update_profile', :contact => {:name => users(:contact).name, :skype => users(:contact).skype, :language => users(:contact).language[0,2].downcase, :password => "contact2", :current_password => "Contacto 1", :password_confirmation => "contact2"}, :locale => 'en'
						response.should redirect_to "/en/users/edit_profile"
					end
				end
			end

			context "User doesn't want to change password." do
				context "Missing attributes for user." do
					it "Trying to update the user identified by id = 2 with a blank name." do
						post 'update_profile', :contact => {:name => "", :password => "", :password_confirmation => "", :current_password => ""}, :locale => 'en'
						response.should render_template "edit_profile"
					end

					it "Trying to update the user identified by id = 2 with a blank skype." do
						post 'update_profile', :contact => {:skype => "", :password => "", :password_confirmation => "", :current_password => ""}, :locale => 'en'
						response.should render_template "edit_profile"
					end
				end

				context "No missing attributes for user." do
					it "It fails because 'skype' is already assigned for another user." do
						post 'update_profile', :contact => {:name => "Contact 3", :skype => users(:admin).skype, :language => users(:contact).language[0,2].downcase, :password => "", :password_confirmation => "", :current_password => ""}, :locale => "en"
						response.should render_template "edit_profile"
					end

					it "Updates fields for user identified by id = 2" do
						post 'update_profile', :contact => {:name => "Contact 3", :skype => "skype 3", :language => users(:contact).language[0,2].downcase, :password => "", :password_confirmation => "", :current_password => ""}, :locale => "en"
						response.should redirect_to "/en/users/edit_profile"
					end
				end
			end
		end
	end

	describe "#update_contact" do
		context "Problems with attributes for user" do
			it "It fails because the user doesn't have a name." do
				request.env["HTTP_REFERER"] = "http://localhost:3000/en/users/edit_contact?id=1"
				post 'update_contact', :contact => {:name => "", :email => "con1@cli1.com", :skype => "Contact 1"}, :id => 1, :locale => 'en'
				response.should redirect_to :back
			end

			it "It fails because 'skype' is already assigned for another user." do
				request.env["HTTP_REFERER"] = "http://localhost:3000/en/users/edit_contact?id=1"
				post 'update_contact', :contact => {:name => "Contact 3", :email => "con1@cli1.com", :skype => users(:admin).skype}, :id => 1, :locale => "en"
				response.should redirect_to :back
			end
		end

		context "All attributes for user exists" do
			it "Updates fields for user identified by id = 2" do
				post 'update_contact', :contact => {:name => "Contact 3", :email => "con1@cli1.com", :skype => "skype 3"}, :id => 1, :locale => "en"
				response.should redirect_to "/en/clients/1"
			end
		end
	end

	describe "#destroy" do
		it "Destroys user identified by id = 1" do
			post 'destroy', :id => 1, :locale => "en"
			response.should redirect_to users_url
		end
	end

	describe "#activity_list" do
		it "Lists the latest activities." do
			post 'activity_list', :locale => "en"
			response.should render_template 'activity_list'
		end
	end
end