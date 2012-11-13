module ActivitiesHelper
	def category_activities(category_id)
		#given a category this will return the number of activities that fall into all it's subcategories
		# debugger
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
end
