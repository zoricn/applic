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
  PENDING_STATUSES = [ STATUS_PENDING, STATUS_PROCESS ]
  CLOSED_STATUS = [STATUS_REJECTED, STATUS_CLOSED, STATUS_ARCHIVED]

  belongs_to :position
  belongs_to :user
  has_many :attachments

  attr_writer :files

  before_create :generate_token
  after_create :pending!
  #after_save :save_attachments

  accepts_nested_attributes_for :attachments

  scope :open, -> {where("status IN (?)", OPEN_STATUSES)}
  scope :accepted, -> { where(:status => STATUS_ACCEPTED) }
  scope :rejected, -> { where(:status => STATUS_REJECTED) }
  scope :desc, order("created_at DESC")
  scope :asc, order("created_at ASC")

  #DEPRECATED
  def save_attachments
    self.files.each do |f|
      self.attachments.create!(:file => f, :position_request_id => self.id)
    end unless self.files.nil?
  end

  def reject!
   return if !self.status_open?
   self.status = STATUS_REJECTED
   save!
   MailWorker.perform_async("RequestMailer", :request_rejected, self.id)
  end

  def accept!
   return if !(PENDING_STATUSES.include? self.status)
   self.status = STATUS_ACCEPTED
   save!
   MailWorker.perform_async("RequestMailer", :request_accepted, self.id)
  end

  def pending!
   self.status = STATUS_PENDING
   save!
   MailWorker.perform_async("RequestMailer", :request_received, self.id)
  end

  def process!
   self.status = STATUS_PROCESS
   save!
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

  def rejected?
    self.status == STATUS_REJECTED
  end

  def accepted?
    self.status == STATUS_ACCEPTED
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
    if self.applicant
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
    str = ""
    self.applicant.each {|key, value| str += "<p>" + key + ":" + value + "</p>" }
    str.html_safe
  end

  def new_comments?(user)
    return unless user == self.position.owner #Return only if owner viewing it
    self.position.owner.last_sign_in_at < self.comments.last.created_at unless self.comments.empty?
  end

  def request_mail_signature
    "CEO, Kolosek IT<br />
    Bulevar Oslobodjenja 11-13, Novi Sad, Serbia<br />
    www.kolosek.com".html_safe
  end

  protected

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless PositionRequest.exists?(token: random_token)
    end
  end
end
