require 'spec_helper'

describe "#mood_number" do
	fixtures :moods

	it "Checks the number of a mood." do
		mood1 = moods(:one)
		mood2 = moods(:two)
		mood3 = moods(:three)
		mood4 = moods(:four)
		mood5 = moods(:five)
		mood1.mood_number.should equal 2
		mood2.mood_number.should equal 0
		mood3.mood_number.should equal 1
		mood4.mood_number.should equal 4
		mood5.mood_number.should equal 3
	end
end