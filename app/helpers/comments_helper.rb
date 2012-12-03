module CommentsHelper

	def send_emails_for_new_comment
    	@activity.users.each do |participant|
			if participant.notf_new_comment
				if participant != current_user
	    			UserMailer.new_comment(participant, @activity, @comment, @comment_writer).deliver
	    		end
			end
		end
    end
    
end