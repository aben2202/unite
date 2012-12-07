module GroupsHelper

	def get_group_row_class(group)
		if signed_in? && current_user.member?(group)
			if group.open_to_public?
				"group-member"
			else
				"group-member private-group"
			end
		end
	end
end
