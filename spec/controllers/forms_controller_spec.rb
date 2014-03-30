  require 'spec_helper'

describe FormsController do
  fixtures :forms, :users, :clients, :projects

  before(:each) do
    session[:user_id] = users(:admin).id
  end
  
  describe "#index" do
    it "Should show all the forms." do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'es-ES'
      get 'index'
      response.should render_template 'index'
    end
  end
  
  describe "#new" do
    it "Should render the view of the form for a new form." do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'es-ES'
      get 'new'
      response.should render_template 'new'
    end
  end
  
 describe "#create" do
    context "Create fails." do
      it "Should fail because some of the attributes are not present." do
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'es-ES'
        post 'create', :form => {:title => 'Form2', :language => 'English', :description => 'Description2', :client_url => 'https://docs.google.com/s3'}
        response.should render_template 'new'
      end

      it "Fails because user isn't a mooveit user." do
        session[:user_id] = users(:contact).id
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'es-ES'
        post 'create', :form => {:title => 'Form2', :language => 'English', :description => 'Description2', :client_url => 'https://docs.google.com/s3'}
        response.should redirect_to root_url
      end
    end
    
    context "Create success." do
      it "Should success when you pass all the params." do
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'es-ES'
        post 'create', :form => {:title => 'Form2', :language => 'English', :description => 'Description2', :client_url => 'https://docs.google.com/spreadsheet/viewform?pli=1&formkey=dGxjS2hZV1RIVWdKaG9GRThHZG5Ib0E6MQ', :admin_url => 'https://docs.google.com/spreadsheet/ccc?key=0AvBAC99RGan7dHJKRzAxMW1YMlpONGdKSDI0Z1ZUUFE', :date => '2012-10-10'}
        response.should redirect_to '/es/forms'
      end
    end
  end
  
  describe "#destroy" do
    it "Should be success." do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'es-ES'
      delete 'destroy', :id => forms(:one).id
      response.should redirect_to forms_url
    end
  end

  describe "#send_view" do
    it "Returns all clients." do
      post 'send_view', :id => forms(:one).id, :locale => 'en'
      response.should render_template 'send_view'
    end
  end

  describe "#get_projects" do
    it "Returns all projects of a given client." do
      post 'get_projects', :id => clients(:one).id, :locale => 'en'
      response.should render_template 200
    end
  end

  describe "#send_form" do
    it "Sends forms for each contact of a set of clients." do
      post 'send_form', :form_send => {:clients => [clients(:one).id, clients(:two).id], :projects => projects(:one).id, :subject => "Subject 1", :message => "Message 1"}, :id => forms(:three).id, :locale => 'en'
      response.should redirect_to "/en/forms"
    end
  end

  describe "#summary" do
    it "Obtains all summaries." do
      post 'summary', :id => forms(:one).id, :locale => 'en'
      response.should render_template 'summary'
    end
  end

  describe "#summary_token" do
    it "Displays the summary of a form." do
      post 'summary_token', :id => forms(:one).id, :proj_id => projects(:one).id, :locale => 'en'
      response.should redirect_to GData::Auth::AuthSub.get_url("http://test.host/en/forms/show_summary?id=#{forms(:one).id}&proj_id=#{projects(:one).id}", 'https://docs.google.com/feeds', false, true)
    end
  end
end
