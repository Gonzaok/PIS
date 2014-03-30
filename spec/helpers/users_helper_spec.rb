require 'spec_helper'

describe UsersHelper do
	fixtures :users, :comments, :contents, :moods, :projects, :milestones, :forms, :clients

	describe "#user_name" do
		it "Obtains an user's name" do
			user_name(users(:contact)).should eq users(:contact).name
		end
	end

	describe "#recent_activity" do
		it "Shows recent activity." do
			recent_activity.should have_at_least(3).things
		end
	end

  describe "#select_activity" do
  	it "Obtains each activity founded with 'recent_activity'" do
  		list = recent_activity
  		while !list.empty? do
  			select_activity(list.first).should include '</a> <span class="activity-date">-'
  			list.shift
  		end
  		list = recent_activity
  		list.each do |l|
  			l.updated_at += 3.day
  		end
  		while !list.empty? do
  			if (!list.first.instance_of? Form) && (!list.first.instance_of? Mood) && (!list.first.instance_of? Project)
  				select_activity(list.first).should include '</a> <span class="activity-date">-'
  			end
  			list.shift
  		end
  	end
  end

  describe "#select_activity_for_mail" do
  	it "Obtains each activity founded with 'recent activity' and creates an email to client identified by id = 1 with that." do
  		list = recent_activity
  		while !list.empty? do
  			if (!list.first.instance_of? Form)
  				if (list.first.instance_of? Client)
  					if (list.first.id == clients(:one).id)
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
  				elsif (list.first.instance_of? Comment)
  					if (clients(:one).projects.find_by_id(list.first.content.project.id))
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
	  			elsif (list.first.instance_of? Content)
  					if (clients(:one).projects.find_by_id(list.first.project.id))
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
  				elsif (list.first.instance_of? Mood)
  					if (clients(:one).projects.find_by_id(list.first.project.id))
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
  				elsif (list.first.instance_of? Project)
  					if (clients(:one).projects.find_by_id(list.first.id))
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
  				elsif (list.first.instance_of? Milestone)
  					if (clients(:one).projects.find_by_id(list.first.project.id))
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
  				elsif (list.first.instance_of? Contact)
  					if (list.first.id == clients(:one).id)
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
	  			end
	  		end
  			list.shift
  		end
  		list = recent_activity
  		list.each do |l|
  			l.updated_at += 3.day
  		end
  		while !list.empty? do
  			if (!list.first.instance_of? Form) && (!list.first.instance_of? Mood) && (!list.first.instance_of? Project)
  				if (list.first.instance_of? Client)
  					if (list.first.id == clients(:one).id)
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
  				elsif (list.first.instance_of? Comment)
  					if (clients(:one).projects.find_by_id(list.first.content.project.id))
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
	  			elsif (list.first.instance_of? Content)
  					if (clients(:one).projects.find_by_id(list.first.project.id))
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
  				elsif (list.first.instance_of? Milestone)
  					if (clients(:one).projects.find_by_id(list.first.project.id))
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
  				elsif (list.first.instance_of? Contact)
  					if (list.first.id == clients(:one).id)
  						select_activity_for_mail(list.first, clients(:one)).should include '</a> <span class="activityDate">'
  					end
	  			end
	  		end
	  		list.shift
  		end
  	end
  end
end