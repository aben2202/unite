class Activity < ActiveRecord::Base
  attr_accessible :title, :description, :its_on, :max_participants, :min_participants, 
                  :when, :category_id, :group_ids

  has_one :location

  has_many :participations, foreign_key: "activity_id", dependent: :destroy
  has_many :users, through: :participations

  has_many :activity_group_relations, foreign_key: "activity_id", dependent: :destroy
  has_many :groups, through: :activity_group_relations

  has_many :comments

  after_create :auto_add_creator_to_participants

  validates :title,				presence: true
  validates :min_participants, 	presence: true
  validates :when,				presence: true

  private
    def auto_add_creator_to_participants
      creator = User.find(self.creator_id)
      creator.participate!(self)
    end
end
