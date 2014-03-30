require 'spec_helper'

describe PasswordResetsController do
	fixtures :users

  describe "#create" do
    context "Can't create." do
      it "Fails because user's email doen't exists." do
        post 'create', :email => "user1@user1.com", :locale => "en"
        response.should redirect_to sessions_url
        flash[:error].should_not be_nil
      end
    end

    context "Create succesful" do
      it "Sends password reset's mail." do
        post 'create', :email => users(:contact).email, :locale => "en"
        response.should redirect_to sessions_url
        flash[:success].should_not be_nil
      end
    end
  end

  describe "#edit" do
  	it "Finds user by password reset's token" do
  		post 'edit', :id => users(:contact).password_reset_token, :locale => 'en'
  		response.should render_template 'edit'
  	end
  end

  describe "#update" do
  	context "Can't update user's password" do
  		it "Token has expired." do
  			users(:contact).update_attributes(:password_reset_sent_at => Time.zone.now - 60*60*3)
  			post 'update', :id => users(:contact).password_reset_token, :locale => "en"
  			response.should redirect_to new_password_reset_path
  		end

  		it "Token is valid. Password and password_confirmation isn't match." do
  			users(:contact).update_attributes(:password_reset_sent_at => Time.zone.now - 60*60*1)
  			post 'update', :id => users(:contact).password_reset_token, :contact => {:password => "A password", :password_confirmation => "Another password"}, :locale => "en"
  			response.should render_template 'edit'
  		end

      it "New password is empty." do
        users(:contact).update_attributes(:password_reset_sent_at => Time.zone.now - 60*60*1)
        post 'update', :id => users(:contact).password_reset_token, :contact => {:password => "", :password_confirmation => ""}, :locale => "en"
        response.should render_template 'edit'
      end
  	end

  	context "Updates user's password." do
      context "User is a contact." do
        it "Token is valid and new password isn't empty." do
          users(:contact).update_attributes(:password_reset_sent_at => Time.zone.now - 60*60*1)
          post 'update', :id => users(:contact).password_reset_token, :contact => {:password => "A password", :password_confirmation => "A password"}, :locale => "en"
          response.should redirect_to sessions_url
        end
      end

      context "User is a mooveit user." do
        it "Token is valid and new password isn't empty." do
          users(:mooveit).update_attributes(:password_reset_sent_at => Time.zone.now - 60*60*1)
          post 'update', :id => users(:mooveit).password_reset_token, :mooveit_user => {:password => "A password", :password_confirmation => "A password"}, :locale => "en"
          response.should redirect_to sessions_url
        end
      end
  	end
  end
end
