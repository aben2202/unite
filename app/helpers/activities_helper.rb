module ActivitiesHelper
	def category_activities(category_id)
		#given a category this will return all the activites that fall in that category
		current_category = Category.find(category_id)
		if current_category.leaf # base case
			return Activity.where(category_id: current_category.id)
		else
			subcategories = Category.where(parent_category_id: category_id)
			activities = []
			subcategories.each do |subc|
				activities += category_activities(subc.id)
			end
			return activities
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
		image_tag("#{category.image_path}", height: 35, width: 35)
	end

	def get_activity_row_class(activity)
		if activity.its_on? 
          "its-on"
        else
          "its-off"
        end
    end

    def get_activity_row_color(activity)
		if activity.its_on? 
			if activity.users.count < activity.max_participants
          		"99FF99"
        	else
          		"FF9999"
        	end
        else
        	"FFFFFF"
        end
    end
end
