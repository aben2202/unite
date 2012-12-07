class Invite < ActiveRecord::Base
  attr_accessible :guest_id, :group_id

  validates :guest_email,	presence: true
  VALID_EMAIL = %r([a-z0-9!#$&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)\b)
  validates :guest_email, 	format: { with: VALID_EMAIL }
  validates :host_id, 		presence: true
  validates :group_id, 		presence: true

end
