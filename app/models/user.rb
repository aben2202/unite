class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,   #added by devise
  				  :first_name, :last_name, :username, :age, :zipcode,		           #general info
            :public_distance_notf_max,  #max distance to notify for public activities
            :notf_new_activity, :notf_activity_turns_on, :notf_new_comment   #notifications

  geocoded_by :zipcode
  after_validation :geocode
  				 
  #Activity participation associations
  has_many :participations, foreign_key: "user_id"
  has_many :activities, through: :participations

  #Group membership associations
  has_many :group_memberships, foreign_key: "member_id"
  has_many :groups, through: :group_memberships

  #Category subscription associations
  has_many :subscriptions, foreign_key: "subscriber_id"
  has_many :categories, through: :subscriptions

  #Comment associations
  has_many :comments

  #validations
  validates :username,  			presence: true,  uniqueness: { case_sensitive: false }
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
    #subscribe, if not already, and then do the same with all subcategories
    if !subscribing?(category)
      self.subscriptions.create!(category_id: category.id)
    end
    if !category.leaf?
      subcategories = Category.where(parent_category_id: category.id)
      subcategories.each do |subc|
        self.subscribe!(subc)
      end
    end
  end

  def unsubscribe!(category)
    #unsubscribe, if subscribing, and then do the same with all subcategories
    if subscribing?(category)
      self.subscriptions.find_by_category_id(category.id).destroy
    end
    if !category.leaf?
      subcategories = Category.where(parent_category_id: category.id)
      subcategories.each do |subc|
        self.unsubscribe!(subc)
      end
    end
 end

  private
    def add_to_public_group
      public_group = Group.find(1)
      self.join_group!(public_group)
    end
end
