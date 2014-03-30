require 'spec_helper'

describe MoodsHelper do
	fixtures :users, :projects, :moods

	describe "#mood_balance" do
		it "Calculates a balance of all moods." do
			mood_balance.should_not be 0
		end
	end

	describe "#is_contact?" do
		it "Checks if logged user is a contact." do
		# Simulate current_user
	    session[:user_id] = users(:contact).id
	    is_contact?.should be true
	  end
	end
end