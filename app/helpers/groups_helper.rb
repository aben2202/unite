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
			invite = Invite.new(group_id: group.id, host_id: current_user.id, guest_email: email)
			invite.save
			UserMailer.group_invite(email, group).deliver
		end
	end
end
