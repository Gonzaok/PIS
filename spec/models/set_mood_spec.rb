require 'spec_helper'

describe SetMood do
  fixtures :moods

  describe "#clean_old_set_moods" do
  	it "Destroys all set moods." do
		SetMood.clean_old_set_moods
		SetMood.count.should eq(0)
	end
  end
end
