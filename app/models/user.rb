class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,  #added by devise
  				  :first_name, :last_name, :username, :age, :zipcode		#general info
  				 
  #Activity participation associations
  has_many :participations, foreign_key: "user_id"
  has_many :activities, through: :participations

  #Group membership associations
  has_many :group_memberships, foreign_key: "member_id"
  has_many :groups, through: :group_memberships

  #Category subscription associations
  has_many :subscriptions, foreign_key: "subscriber_id"
  has_many :categories, through: :subscriptions

  #validations
  validates :username,  			presence: true
  validates :age,       			presence: true
  validates :zipcode,   			presence: true

  after_create :add_to_public_group

  # attr_accessible :title, :body

  #Activity association methods ##############################################
  def participating?(activity)
    self.participations.find_by_activity_id(activity.id)
  end

  def participate!(activity)
    self.participations.create!(activity_id: activity.id)
  end

  def quit!(activity)
    self.participations.find_by_activity_id(activity.id).destroy
  end


  #Group membership association methods #####################################
  def member?(group)
    self.group_memberships.find_by_group_id(group.id)
  end

  def join_group!(group)
    self.group_memberships.create!(group_id: group.id)
  end

  def leave_group!(group)
    self.group_memberships.find_by_group_id(group.id).destroy
  end


  #Category subscription methods ###########################################
  def subscribing?(category)
    self.subscriptions.find_by_category_id(category.id)
  end

  def subscribe!(category)
    self.subscriptions.create!(category_id: category.id)

    #we need to subscribe them to all subcategories as well
  end

  def unsubscribe!(category)
    self.subscriptions.find_by_category_id(category.id).destroy

    #we need to unsubscribe them from all subcategories as well
  end

  private
    def add_to_public_group
      public_group = Group.find(1)
      self.join_group!(public_group)
    end
end