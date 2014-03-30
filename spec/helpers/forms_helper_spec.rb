require 'spec_helper'

describe FormsHelper do
	fixtures :forms, :projects

	describe "#mood_list" do
		it "Generates an array of moods" do
			mood_list.should eql([I18n.t('mood.' + "angry"), I18n.t('mood.' + "sad"), I18n.t('mood.' + "neutral"), I18n.t('mood.' + "satisfied"), I18n.t('mood.' + "happy")])
		end
	end

	 describe "#retrieve_data" do
	 	it "Gets the general opinions for a given project" do
	 		retrieve_data([['Time Stamp','Project ID','General Opinion'],['1','1','5'],['1','1','3'],['','2','3']],1).should eql(['5','3'])
	 	end
   end

end
