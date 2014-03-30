require 'spec_helper'

describe MoodsController do
  fixtures :clients, :projects, :users, :moods

  before(:each) do
    session[:user_id] = users(:contact).id
  end

  describe "#index" do
    it "Lists all moods." do
      post 'index', :locale => 'en'
      response.should render_template "index"
    end
  end

  describe "#new" do
    it "Should show the form for the mood." do
      get 'new', :locale => 'en'
      response.should render_template "new"
    end
  end

  describe "#edit" do
    it "Finds the mood identified by id = 1." do
      get 'edit', :id => moods(:one).id, :locale => 'en'
      response.should render_template "edit"
    end
  end
  
  describe "#create" do
    context "Missing attributes for mood." do
      it "Fails because was not selected any mood." do
        post 'create', :comment => [moods(:one).comment], :id_user => moods(:one).user_id, :id_project => moods(:one).project_id, :locale => 'en'
        response.should redirect_to projects(:one)
      end
    end
    
    context "No missing attributes for mood." do
      it 'Creates a new mood of "Client 1" for "Project 1"' do
        post 'create', :mood => moods(:one).mood, :comment => [moods(:one).comment], :id_user => moods(:one).user_id, :id_project => moods(:one).project_id, :locale => 'en'
        response.should redirect_to projects(:one)
      end

      it "Fails because doesn't exists a logged user." do
        session[:user_id] = nil
        post 'create', :comment => [moods(:one).comment], :id_user => moods(:one).user_id, :id_project => moods(:one).project_id, :locale => 'en'
        response.should redirect_to root_url
      end
    end
  end

  describe "#update" do
    context "Missing attributes for mood." do
      it "Fails because was not selected any mood." do
        post 'update', :id => moods(:one).id, :mood => {:mood => nil, :comment => [moods(:one).comment], :user_id => moods(:one).user_id, :project_id => moods(:one).project_id}, :locale => 'en'
        response.should redirect_to "/en/projects/#{moods(:one).project_id}"
      end
    end

    context "No missing attributes for mood." do
      it 'Updates the mood of "Client 1" for "Project 1"' do
        request.env["HTTP_REFERER"] = "http://test.host/en/projects/#{moods(:one).project_id}"
        post 'update', :id => moods(:one).id, :mood => {:mood => moods(:two).mood, :comment => [moods(:one).comment], :user_id => moods(:one).user_id, :project_id => moods(:one).project_id}, :locale => 'en'
        response.should redirect_to :back
      end 
    end
  end

  describe "#destroy" do
    it 'Detroys the mood identified by id = 1' do
      post 'destroy', :id => moods(:one).id, :locale => 'en'
      response.should redirect_to moods_url
    end
  end
end