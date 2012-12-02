class Activity < ActiveRecord::Base
  attr_accessible :title, :description, :its_on, :max_participants, :min_participants, 
                  :date_and_time, :where, :zipcode, :category_id, :group_ids

  geocoded_by :zipcode
  after_validation :geocode

  has_one :location

  has_many :participations, foreign_key: "activity_id"
  has_many :users, through: :participations

  has_many :activity_group_relations, foreign_key: "activity_id"
  has_many :groups, through: :activity_group_relations

  has_many :comments

  after_create :auto_add_creator_to_participants

  validates :title,				      presence: true
  validates :min_participants, 	presence: true
  validates :date_and_time,			presence: true
  VALID_ZIPCODE_REGEX = %r(\b[0-9]{5}(?:-[0-9]{4})?\b)
  validates :zipcode,           presence: true, format: { with: VALID_ZIPCODE_REGEX },
                                numericality: { greater_than: 9999, less_than: 100000 }

  private
    def auto_add_creator_to_participants
      creator = User.find(self.creator_id)
      creator.participate!(self)
    end
end
