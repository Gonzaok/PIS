require 'spec_helper'

describe SetMoodController do
	fixtures :projects, :clients, :set_moods, :moods, :users

  describe "#create" do
    context "Creates and send an email for the contacts of a project to change mood." do
      it "Project isn't filed." do
        #Simulates current_user
        session[:user_id] = users(:admin).id
        post 'create', :id_project => projects(:one).id, :locale => 'en'
        response.should redirect_to projects(:one)
        flash[:success].should_not be_nil
      end
    end

    context "Can't creates and send an email for the contacts of a project to change mood." do
      it "Fails because project is filed." do
        #Simulates current_user
        session[:user_id] = users(:admin).id
        post 'create', :id_project => projects(:two).id, :locale => 'en'
        response.should redirect_to projects(:two)
        flash[:error].should_not be_nil
      end

      it "Fails because user isn't an admin." do
        #Simulates current_user
        session[:user_id] = users(:contact).id
        post 'create', :id_project => projects(:one).id, :locale => 'en'
        response.should redirect_to root_url
      end
    end
  end

  describe "#set_mood" do
    context "Can't update mood." do
      it 'Fails because the "mood" field is nil.' do
        post 'set_mood', :token => set_moods(:one).set_mood_token, :comment => "This is a comment", :locale => "en"
        response.should redirect_to "/en/projects/#{set_moods(:one).project_id}"
      end

      it "Fails because token doesn't exists." do
        post 'set_mood', :token => 123, :comment => "This is a comment", :locale => "en"
        response.should redirect_to root_url
      end
    end

    context "Updates mood." do
    	it "All fields are completes." do
  			post 'set_mood', :token => set_moods(:one).set_mood_token, :mood => "Sad", :comment => "This is a comment", :locale => "en"
        response.should render_template "set_comment"
  		end
    end
  end

  describe "#set_comment" do
    context "Can't set a comment on a mood." do
      it "Fails because user can't access to the project of the mood." do
        #Simulates current_user
        session[:user_id] = users(:contact).id
        post 'set_comment', :mood => moods(:eight).id, :locale => 'en'
        response.should redirect_to sessions_url
      end
    end

    context "Sets a comment on a mood." do
      it 'Mood is "complete"' do
        #Simulates current_user
        session[:user_id] = users(:contact).id
        post 'set_comment', :mood => moods(:six).id, :comment => {:comment => "Comment 6"}, :locale => 'en'
        response.should render_template 'set_comment'
      end

      it "Mood doesn't have a comment." do
        #Simulates current_user
        session[:user_id] = users(:contact).id
        post 'set_comment', :mood => moods(:one).id, :locale => 'en'
        response.should redirect_to sessions_url
      end
    end
  end
end
