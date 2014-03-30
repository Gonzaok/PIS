require 'spec_helper'

describe ClientsHelper do
	fixtures :clients

	describe "#image_client" do
		context "User doesn't have an image." do
			it "Render a default image." do
				image_client(clients(:two), :big).should include "missing_big.png"
			end
		end

		context "User have an image." do
			it "Render the image of the client." do
				image_client(clients(:one), :big).should include clients(:one).image_file_name
			end
		end
	end
end