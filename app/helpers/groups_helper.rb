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

	def send_invite_emails(group, emails)
		for email in emails do
			user = User.find_by_email(email)
			if user != nil
				invite = Invite.new(group_id: group.id, host_id: current_user.id, guest_email: user.id)
				invite.save
			else #email belongs to non-user

			

		debugger
		#do stuff here
	end
end
