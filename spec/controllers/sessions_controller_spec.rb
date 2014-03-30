require 'spec_helper'

describe SessionsController do
  fixtures :users

  describe "#new" do
    it 'Do "new".' do
      post 'new', :locale => 'en'
      response.should render_template 200
    end
  end

  describe "#create" do
    context "Some error occurred during OpenId login." do
      it "No response received from OpenId." do
        request.env[Rack::OpenID::RESPONSE] = nil
        post 'create', :locale => 'en'
        response.should redirect_to new_session_path
      end
    end
  end

  describe "#index" do
    it "Should render the layout login." do
      get 'index', :locale => 'en'
      response.should render_template "index"
    end
  end
  
  describe "#client_login" do
    context "Login successful." do
      it "Should render to the home/index." do
        request.env['HTTP_ACCEPT_LANGUAGE'] = "en"
        post 'client_login', :email => users(:contact).email, :password => "Contacto 1"
        response.should redirect_to(:controller=>'home', :action=>'index')
      end
    end

    context "Login unsuccessful." do
      it "Doesn't exists an user identified by 'email'." do
        post 'client_login', :email => "e@mail.com", :password => "cont", :locale => 'en'
        response.should redirect_to sessions_url
      end

      it "Incorrect password for user identified by 'email'." do
        post 'client_login', :email => users(:contact).email, :password => "cont", :locale => 'en'
        response.should render_template "index"
      end
    end
  end

  describe "#destroy" do
    it "Destroys actual user." do
      post 'destroy', :locale => 'en'
      response.should redirect_to "/"
    end
  end
end
