class ActivityGroupRelation < ActiveRecord::Base
  attr_accessible :activity_id, :group_id

  belongs_to :activity
  belongs_to :group

  validates :activity_id, 	presence: true
  validates :group_id, 		presence: true
  validates_uniqueness_of :activity_id, scope: :group_id
end
