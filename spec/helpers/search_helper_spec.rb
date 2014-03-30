require 'spec_helper'

describe SearchHelper do
	fixtures :projects, :clients, :users, :contents

	describe "#results" do
		it "Prints results for a search." do
			results(Time.zone.now, [projects, clients, users]).should have_at_least(4).projects
			results(Time.zone.now, [projects, clients, users]).should have_at_least(2).clients
			results(Time.zone.now, [projects, clients, users]).should have_at_least(4).users
		end
	end

	describe "#get_gravatar_url" do
		it "Get gravatar's user url." do
			get_gravatar_url(users(:contact), 25).should include "www.gravatar.com"
		end
	end

	describe "#content_part" do
		it "Parsing the summary of a content, to be shown in the search bar." do
			content_part(contents(:one).summary, "mma").should include "#{contents(:one).summary}"
		end
	end
end