require 'spec_helper'

describe ContentsHelper do
	fixtures :users, :contents, :projects

	describe "#user_contact?" do
		it "Checks if an user is a contact." do
			user_contact?(users(:contact).id, contents(:one), {:access_moove_it => true, :access_client => false}).should include '<div class="btn-group pull-left">'
		end
	end

	describe "#star_ranking" do
		it "Checks if an user is an admin." do
			session[:user_id] = users(:admin).id
			@project = Project.find(contents(:one).project_id)
			star_ranking(contents(:one)).should include '<div class="row">'
		end
	end

	describe "#star_ranking_static" do
		it 'Renders "static" ranking of a content' do
			star_ranking_static(contents(:one)).should include "#{'<img src="/assets/star-on.png">'*contents(:one).ranking + '<img src="/assets/star-off.png">'*(5-contents(:one).ranking)}"
		end
	end
end
