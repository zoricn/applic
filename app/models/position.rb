class Position < ActiveRecord::Base
  belongs_to :user
  has_many :position_requests
  has_many :participants, through: :position_requests

  #scope :active, where(:status => STATUS_COLLECTED)


  def owner? user
    self.user == user
  end

  def applied?(user)
    !user.nil? && (!self.position_requests.where(:user_id => user.id).empty? || self.owner?(user))
  end

  def not_applied?(user)
    !self.applied? user
  end

  def applicants_count?
    self.position_requests.count + 1 # + owner who is not included
  end

  def is_owner?(entity)
    self.owner == entity
  end

  def can_be_requested?
    true
  end

  def owner
    self.user
  end

  def user_position_request(user)
    self.position_requests.where(:user_id => user.id).first
  end

  def already_requested?(entity)
    #!self.position_requests.where(:user_id => entity.id, :requester_type => "User").empty?
    !self.position_requests.where(:user_id => entity.id).empty?
  end

  def not_requested?(entity)
    self.position_requests.where(:user_id => entity.id).empty?
  end

  def pending_requests?
    self.position_requests.where(:status => PositionRequest::STATUS_PENDING)
  end

  def short_description
    self.description.truncate(100, separator: ' ')
  end
end
