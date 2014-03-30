require 'spec_helper'

describe ClientsController do
  fixtures :clients, :users

  before(:each) do
    session[:user_id] = users(:admin).id
  end

  context "#index" do
    it "Should list all the clients in the database with the view index." do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'es-ES'
      get 'index'
      response.should render_template 'index'
    end
  end

  context "#show" do
    it "Should show the data of the client Client 1 with the view show." do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'es-ES'
      get 'show', :id => clients(:one).id
      response.should render_template 'show'
    end
  end

  context "#new" do
    it "Should show the form for the new client." do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'es-ES'
      get 'new'
      response.should render_template 'new'
    end
  end

  context "#edit" do
    it "Should show the form for editing a client." do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'es-ES'
      get 'edit', :id => clients(:two).id
      response.should render_template 'edit'
    end
  end

  context "#create" do
    context "create success" do
      it "Should show success on saving the client and render to the view of the client." do
        post 'create', :client => {:name => "Client Test Controller 2", :language => "Spanish", :contacts_attributes => {"0" => {:name => "Contact 3", :email => "c3@c3.com", :skype => "s3"}}}, :locale => 'es'
        @client = Client.find_by_name("Client Test Controller 2")
        response.should redirect_to("/es/clients/"+@client.id.to_s)
      end
    end

    context "create fail" do
      it "Should render to action new when params of the client are missing." do
        post 'create', :client => {:language => 'Spanish', :contacts_attributes => {"0" => {:name => "Contact 1", :email => "", :skype => "s1"}}}, :locale => 'es'
        response.should render_template 'new'
      end

      it "Should render to action new when it fails on saving two contacts for the client." do
        post 'create', :client => {:name => "Client Test Controller", :language => "Spanish", :contacts_attributes => {"0" => {:name => "Contact 1", :email => "c1@c1.com", :skype => "s1"}, "1" => {:name => "Contact 2", :email => "c2@c2.com", :skype => "s1"}}}, :locale => 'es'
        response.should render_template 'new'
      end

      it "Should render to action new when two or more contacts have same email." do
        post 'create', :client => {:name => "Client Test Controller", :language => "Spanish", :contacts_attributes => {"0" => {:name => "Contact 1", :email => "c1@c1.com", :skype => "s1"}, "1" => {:name => "Contact 2", :email => "c1@c1.com", :skype => "s2"}}}, :locale => 'es'
        response.should render_template 'new'
      end

      it "Should show success on saving the client and render to the view of the client." do
        post 'create', :client => {:name => "Client Test Controller 2", :language => "Spanish", :contacts_attributes => {"0" => {:name => "Contact 3", :email => "c3@c3.com", :skype => "s3"}}}, :locale => 'es'
        @client = Client.find_by_name("Client Test Controller 2")
        response.should redirect_to("/es/clients/"+@client.id.to_s)
      end

      it "Should render to action new when there is already a client with the same name." do
        post 'create', :client => {:name => clients(:one).name, :language => "Spanish", :contacts_attributes => {"0" => {:name => "Contact 2", :email => "c2@c2.com", :skype => "s2"}}}, :locale => 'es'
        response.should render_template(:new)
      end
    end
  end

  context "#update" do
    it "Update should be success." do
      put 'update', :id => clients(:one).id, :client => {:language => "Spanish"}, :locale => 'es'
      response.should redirect_to "/es/clients/#{clients(:one).id}"
    end

    it "Update should not be success, the new name exist on the database." do
      put 'update', :id => clients(:one).id, :client => {:name => clients(:two).name}, :locale => 'es'
      response.should render_template 'edit'
    end
  end

  context "#destroy" do
    it "Should be success." do
      delete 'destroy', :id => clients(:one).id, :locale => 'en'
      response.should redirect_to clients_url
    end
  end

  context "#my_client" do
    it "Returns the client of contact identified by id = 1." do
      session[:user_id] = users(:contact).id
      post 'my_client', :locale => 'en'
      response.should render_template 'my_client'
    end
  end
end
