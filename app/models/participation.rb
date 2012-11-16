class Participation < ActiveRecord::Base
  attr_accessible :activity_id, :user_id

  belongs_to :user
  belongs_to :activity

  after_create :check_if_activity_is_on
  after_destroy :check_if_activity_is_on

  validates :activity_id, 	presence: true
  validates :user_id, 		presence: true
  validates_uniqueness_of :activity_id, scope: :user_id

  private 
  	def check_if_activity_is_on
  		act = Activity.find(self.activity_id)
  		if !act.its_on? && act.users.count >= act.min_participants
  			act.update_attributes(its_on: true)
  		elsif act.its_on? && act.users.count < act.min_participants
  			act.update_attributes(its_on: false)
  		end
  	end
end
