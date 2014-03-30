require 'spec_helper'

describe SessionsHelper do
	fixtures :users

	describe "#get_gravatar" do
		it "Gets and render user's gravatar." do
			get_gravatar(users(:contact), 25).should include "<img src="
		end
	end

	describe "#get_rounded_gravatar" do
		context "User doesn't exists." do
			it "User is nil." do
				get_rounded_gravatar(nil, 25).should include "http://www.gravatar.com/avatar/64e1b8d34f425d19e1ee2ea7236d3028?size=25"
			end
		end

		context "User exists." do
			it "Gets and render (roounded) user's gravatar." do
				get_rounded_gravatar(users(:contact), 25).should include "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(users(:contact).email.downcase)}?size=25"
			end
		end
	end
end