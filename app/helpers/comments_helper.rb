module CommentsHelper

	def send_emails_for_new_comment
    	@activity.users.each do |participant|
			if participant.notf_new_comment
	    		UserMailer.new_comment(participant, @activity, @comment).deliver
			end
		end
    end
    
end