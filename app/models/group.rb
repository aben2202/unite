class Group < ActiveRecord::Base
	attr_accessible :details, :name, :open_to_public

	has_many :group_memberships, foreign_key: "group_id"
	has_many :members, through: :group_memberships

	has_many :activity_group_relations, foreign_key: "group_id"
	has_many :activities, through: :activity_group_relations

	after_create :auto_add_creator_to_members

	validates :name, 			presence: true, uniqueness: { case_sensitive: false }
	validates :creator_id, 		presence: true

  
	def self.search(search)
	  	if !search.blank?
	  		conditions = ["name LIKE (?) AND open_to_public = ?", "%#{search}%", true]
	  	else
	  		conditions = ["open_to_public = ?", true]
	  	end
	     find(:all, conditions: conditions)
	end

	private
	    def auto_add_creator_to_members
	      creator = User.find(self.creator_id)
	      creator.join_group!(self)
	    end
end
