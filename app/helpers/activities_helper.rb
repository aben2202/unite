module ActivitiesHelper
	def category_activities(category_id)
		#given a category this will return the number of activities that fall into all it's subcategories
		# debugger
		current_category = Category.find(category_id)
		if current_category.leaf # base case
			return Activity.count(conditions: "category_id = #{current_category.id}")
		else
			subcategories = Category.where(parent_category_id: category_id)
			subtotal = 0
			subcategories.each do |subc|
				subtotal += category_activities(subc.id)
			end
			return subtotal
		end
	end
end
