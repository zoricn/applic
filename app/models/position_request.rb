class PositionRequest < ActiveRecord::Base
  acts_as_commentable

  STATUS_PENDING   = 10.freeze
  STATUS_ACCEPTED  = 20.freeze
  STATUS_REJECTED  = 30.freeze
  STATUS_ARCHIVED  = 40.freeze
  STATUS_CLOSED    = 50.freeze

  STATUSES = {
    STATUS_PENDING  => 'pending',
    STATUS_ACCEPTED   => 'accepted',
    STATUS_REJECTED  => 'rejected',
    STATUS_ARCHIVED  => 'archived',
    STATUS_CLOSED  => 'closed'
  }

  ACTIVE_STATUSES = [ STATUS_ACCEPTED, STATUS_REJECTED ]

   #belongs_to :applicant
  belongs_to :position
  belongs_to :user

  before_create :generate_token
  after_create :pending!

  store_accessor :applicant, :first_name, :last_name, :email

  #has_many :applicants
  #accepts_nested_attributes_for :applicants



  def reject!
   return if !(self.status == STATUS_PENDING)
   self.status = STATUS_REJECTED
   Notifications.request_rejected(self)
   save!
  end

  def accept!
   return if !(self.status == STATUS_PENDING)
   self.status = STATUS_ACCEPTED
   Notifications.request_accepted(self)
   save!
  end

  def pending!
   self.status = STATUS_PENDING
   save!
   Notifications.request_received(self)
  end



  def status_closed?
     self.status == STATUS_CLOSED
  end

  def status?
    STATUSES[self.status]
    
  end

  def authorized? entity
    self.position.owner? entity
  end

  def active?
    ACTIVE_STATUSES.include?(self.status)
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
  def entity
    self.applicant["email"] unless self.applicant.nil?
  end

  def applicant_description
    self.applicant["first_name"] + ' ' + self.applicant["last_name"]  
  end

  protected

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless PositionRequest.exists?(token: random_token)
    end
  end
end
