class User
  include Mongoid::Document

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :authentication_token, type: String

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  
  has_many :websites
  
  validates_uniqueness_of :authentication_token
  
  validate do
    self.errors.add :websites, 'must be unique' if websites.map(&:url).uniq.count != websites.count
  end

  index({authentication_token: 1}, :unique => true)
  
  def assign_authentication_token!
    loop do
      self.authentication_token = SecureRandom.urlsafe_base64(30).tr('lIO0', 'sxyz')
      break if User.where(:authentication_token => authentication_token).count == 0
    end
    save
  end
end
