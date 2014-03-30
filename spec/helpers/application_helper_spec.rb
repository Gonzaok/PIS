require 'spec_helper'

describe ApplicationHelper do
	fixtures :clients

	describe "#language_opts" do
		it "Options for language." do
			language_opts.should have(2).items
		end
	end

	describe "#printErrors" do
		context "Several errors." do
			it "Prints all errors." do
				cli = clients(:one)
				cli.errors.add("1", "Error 1")
				cli.errors.add("2", "Error 2")
				cli.errors.add("3", "Error 3")
				printErrors(cli).should include "<ul>"
			end
		end

		context "One error." do
			it "Print the error." do
				cli = clients(:one)
				cli.errors.add("1", "Error 1")
				printErrors(cli).should_not include "<ul>"
			end
		end
	end
end