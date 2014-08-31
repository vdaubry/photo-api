class User
  include Mongoid::Document
  embeds_many :user_websites

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

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

  validates_uniqueness_of :authentication_token

  def assign_authentication_token!
    loop do
      self.authentication_token = SecureRandom.urlsafe_base64(30).tr('lIO0', 'sxyz')
      break if User.where(:authentication_token => authentication_token).count == 0
    end
    save
  end

  def update_websites
    puts "Updating Website #{user_websites.count}"

    user_websites.each do |website|
      puts "Update #{website.name}"
      website.update_posts
    end
  end

  def follow_website(website)
    return if user_websites.where(:website_id => website.id).first.present?

    uw = UserWebsite.new(:website_id => website.id, :name => website.name, :url => website.url)
    user_websites.push(uw)
    uw.update_posts
  end
end
