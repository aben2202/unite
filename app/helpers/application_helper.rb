module ApplicationHelper
    def link_to_group(group)
    	if group.id == 1
    		group.name
    	else
    		link_to "#{group.name}", group_path(group)
    	end
	end	
end
