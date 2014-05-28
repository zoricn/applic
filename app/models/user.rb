class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable

  has_and_belongs_to_many :roles
  has_many :positions
  has_many :position_requests
  has_one :setting

  #after_create :create_settings

  def role?(role)
    return !!self.roles.find_by_name(role.to_s)
  end

  def make_admin
    self.roles << Role.admin
  end

  def revoke_admin
    self.roles.delete(Role.admin)
  end

  def admin?
    role?(:admin)
  end

  def applied_to?
    self.position_requests
  end

  def accepted_requests?
    self.position_requests.where(:status => PositionRequest::STATUS_ACCEPTED)
  end

  def rejected_requests?
    self.position_requests.where(:status => PositionRequest::STATUS_REJECTED)
  end

  def pending_requests?
    self.position_requests.where(:status => PositionRequest::STATUS_PENDING)
  end

  def archived_requests?
    self.position_requests.where(:status => PositionRequest::STATUS_ARCHIVED)
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['info']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end

  private

end
