module GroupsHelper

	def get_group_row_class(group)
		if signed_in? && current_user.member?(group)
			"group-member"
		end
	end
end
