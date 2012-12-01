module ActivitiesHelper
	def category_activities(category_id)
		#given a category this will return all the activites that fall in that category
		current_category = Category.find(category_id)
		all_category_ids = get_all_subcategory_ids(category_id)
		if !signed_in?
			#return all activities in all groups
			return Activity.where(category_id: all_category_ids)
		else
			#only return activities for user groups
			conditions = "groups.id IN (?) AND activities.category_id IN (?) AND 
						  activities.date_and_time > (?)", current_user.group_ids, all_category_ids, Time.now

			return Activity.all(joins: {:groups => :activity_group_relations}, 
                           		group: 'activities.id', 
                           		conditions: conditions )
		end
	end

	def get_all_subcategory_ids(category_id)
		#given a category this will return the list of all its subcategory ids
		current_category = Category.find(category_id)
		if current_category.leaf # base case
			return [category_id.to_i]
		else
			subcategories = Category.where(parent_category_id: category_id)
			all_category_ids = []
			subcategories.each do |subc|
				all_category_ids += get_all_subcategory_ids(subc.id)
			end
			return all_category_ids
		end
	end	

	def get_activity_category_image(activity)
		category = Category.find(activity.category_id)
		image_tag("#{category.image_path}", height: 35, width: 35, title: "#{category.name}")
	end

	def get_activity_row_class(activity)
		if activity.its_on? 
			if activity.users.count < activity.max_participants
	          "its-on-open"
	        else
	          "its-on-full"
	        end
	    else
	    	"its-off"
	    end
    end

    def bold_activity?(activity)
    	if signed_in? && current_user.participating?(activity)
    		"bold"
    	end
    end

    def send_emails_for_new_activity
    	sent_to = []
    	@activity.groups.each do |group|
    		group.members.each do |member|
    			if !sent_to.include? member.email
    				if member.notf_new_activity
    					for sub in member.subscriptions do
    						if sub.category_id == @category.id
			    				sent_to += [member.email]
			    				UserMailer.new_activity(member, @activity, @category, group).deliver
			    				break
			    			end
		    			end
	    			end
    			end
    		end
    	end
    end
end
