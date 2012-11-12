class SpecificActivity < ActiveRecord::Base
  attr_accessible :description, :its_on, :max_participants, :min_participants, :when

  has_one :location

  validates :min_participants, 	presence: true
  validates :when,				presence: true
end
