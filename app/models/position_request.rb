class PositionRequest < ActiveRecord::Base
  acts_as_commentable

  STATUS_PENDING   = 10.freeze
  STATUS_ACCEPTED  = 20.freeze
  STATUS_REJECTED  = 30.freeze
  STATUS_ARCHIVED  = 40.freeze
  STATUS_CLOSED    = 50.freeze
  STATUS_PROCESS   = 60.freeze

  STATUSES = {
    STATUS_PENDING  => 'pending',
    STATUS_ACCEPTED   => 'accepted',
    STATUS_REJECTED  => 'rejected',
    STATUS_ARCHIVED  => 'archived',
    STATUS_CLOSED  => 'closed',
    STATUS_PROCESS => 'in process'
  }

  ACTIVE_STATUSES = [ STATUS_ACCEPTED, STATUS_PROCESS ]
  OPEN_STATUSES = [ STATUS_ACCEPTED, STATUS_PENDING, STATUS_PROCESS ]
  CLOSED_STATUS = [STATUS_REJECTED, STATUS_CLOSED, STATUS_ARCHIVED]

   #belongs_to :applicant
  belongs_to :position
  belongs_to :user

  before_create :generate_token
  after_create :pending!

  store_accessor :applicant

  has_many :attachments
  accepts_nested_attributes_for :attachments

  scope :open, -> {where("status IN (?)", OPEN_STATUSES)}
  scope :accepted, -> { where(:status => STATUS_ACCEPTED) }

  def reject!
   return if !self.status_open?
   self.status = STATUS_REJECTED
   save!
   Notifications.request_rejected(self)
  end

  def accept!
   return if !(self.status == STATUS_PENDING)
   self.status = STATUS_ACCEPTED
   save!
   Notifications.request_accepted(self)
  end

  def pending!
   self.status = STATUS_PENDING
   save!
   Notifications.request_received(self)
  end

  def process!
   self.status = STATUS_PROCESS
   save!
   Notifications.request_in_process(self)
  end

  def status_closed?
     self.status == STATUS_CLOSED
  end

  def status?
    STATUSES[self.status]
  end

  def status_open?
    OPEN_STATUSES.include? self.status
  end

  def authorized? entity
    self.position.owner? entity
  end

  def active?
    ACTIVE_STATUSES.include?(self.status)
  end

  def closed?
    CLOSED_STATUS.include?(self.status)
  end

  def owner_commented?
    !self.comments.empty?
  end

  def pending?
    self.status == STATUS_PENDING
  end

  def entity_email
    if self.user
      self.user.try(:email)
    elsif self.applicant
      self.applicant["email"]
    else
      ""
    end
  end

  #Print information about the applicant
  # !! It requires email field!
  def entity
    self.applicant["email"] unless self.applicant.nil?
  end

  def applicant_description
    self.applicant  
  end

  def new_comments?(user)
    return unless user == self.position.owner #Return only if owner viewing it
    self.position.owner.last_sign_in_at < self.comments.last.created_at unless self.comments.empty?
  end

  protected

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless PositionRequest.exists?(token: random_token)
    end
  end
end
