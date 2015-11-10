# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  image                  :string(255)
#  invited_at             :datetime
#  accepted_at            :datetime
#  invitation_id          :integer
#  invitation_limit       :integer
#  state                  :string(255)
#  active                 :boolean
#  invite_token           :string(255)
#  invite_sent_at         :datetime
#  initiate_token         :string(255)
#  dead                   :boolean
#  admin_id               :integer
#  login                  :string(255)
#  birth_year             :date
#  death_year             :date
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :image, :active, :admin_id, :dead, :login, :death_year, :birth_year, :remove_image, :message, :contributor_id
  has_secure_password

  has_many :microposts
  has_many :friends
  has_many :comments, :dependent => :destroy
  has_many :loves, foreign_key: "lover_id", :dependent => :destroy
  has_many :legacy_anthologies, :class_name => "User", :foreign_key => "admin_id"
  belongs_to :admin, :class_name => "User"
  has_one :contributor, :class_name => "User"
  has_many :loved_microposts, through: :loves, source: :loved

  include Amistad::FriendModel
  
  #has_many :relationships, foreign_key: "follower_id"
  #has_many :followed_users, through: :relationships, source: :followed
  #has_many :reverse_relationships, foreign_key: "followed_id",
  #                                 class_name: "Relationship"
  #has_many :followers, through: :reverse_relationships, source: :follower

  before_validation :create_temp_password
  before_save { |user| user.email = user.email.downcase }
  #before_save { |user| user.login = user.login.downcase }
  before_save :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  validates :message, presence: true 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }#,
                    #uniqueness: { case_sensitive: false }
  validates :login, presence: true, uniqueness: { case_sensitive: false }, :on => :update                 
  validates :password, length: { minimum: 6 }, :on => :create 
  validates :password_confirmation, presence: true, :on => :create

  #after_create :create_temp_password
  default_scope order: 'users.name ASC'
  #after_save :create_temp_password
  mount_uploader :image, ImageUploader
  process_in_background :image
  ##def kins
  ##  direct_kins | inverse_kins
  ##end

  def self.search(search, page)
      #find(:all, :conditions => ['name ILIKE ?', "%#{search}%"])

      paginate :per_page => 16, :page => page,
                :conditions => ['name ILIKE ?', "%#{search}%"], :order => 'name'
    
  end

  ##def self.authenticate(conditions)
  ##    conditions[:login].downcase! 
  ##    super(conditions) 
  ##end attempt at downcasing login...it doesn't work!

  #def following?(other_user)
  #  relationships.find_by_followed_id(other_user.id)
  #end

  #def follow!(other_user)
  #  relationships.create!(followed_id: other_user.id)
  #end

  #def unfollow!(other_user)
  #  relationships.find_by_followed_id(other_user.id).destroy
  #end

  def can_love?(micropost)
    loves.build(value: 1, micropost: micropost).valid?
  end

  def send_password_reset
    generate_token(:password_reset_token)
    ##@user = User.find_by_login(params[:login]) ##
    self.password_reset_sent_at = Time.zone.now
    ##@user.password_reset_sent_at = Time.zone.now ## double hashes for trying to create new user!
    save!(validate: false)
    UserMailer.password_reset(self).deliver
    ##UserMailer.password_reset(@user).deliver ##
  end

  def send_notify(micropost_id) # usually no parentheses no micropost_id
    #generate_token(:invite_token) ##
    #self.invite_sent_at = Time.zone.now ##
    #self.contributor_id = User.find_by_remember_token(cookies[:remember_token])
    save!(validate: false)
    UserMailer.notify(micropost_id).deliver #usually says self
  end

  def send_comment_author_notify(comment_id)
    save!(validate: false)
    UserMailer.comment_author_notify(comment_id).deliver
  end

  def send_comment_subject_notify(comment_id)
    save!(validate: false)
    UserMailer.comment_subject_notify(comment_id).deliver
  end

  def send_email_verification #not in use right now; we skipped this step
    generate_token(:invite_token)
    self.invite_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.email_verification(self).deliver
  end

  def send_invite #I might want to add a sender name.
    generate_token(:invite_token)
    self.invite_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.invite(self).deliver
  end

  def send_signup_confirmation
    UserMailer.signup_confirmation(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def show_posts
     #Micropost.where(:subject_id => @user.id).reorder('dateofevent') #DOES THIS WORK?? try 
  end  

  def other_user_index
  end

  def feed
    Micropost.where(["user_id in (?) or subject_id in (?) or user_id in (?) or subject_id in (?)", self.friends, self.friends, self, self])
     #Micropost.where(:subject_id => self.friends)
     #Micropost.where("subject_id =?", self.friends or self && "user_id =?", self.friends)

      #:user_id => self.friends)
    


    
    
     #is this right? or do i take away the or and add the bottom two?
    #right now, without the or, it only takes into account posts your kin have written about your kin. 
  end

  def anthology
    Micropost.where("subject_id = ? or user_id = ?", self.id, self.id).reorder('dateofevent')
  end
  
  def loving?(micropost)
    loves.find_by_loved_id(micropost.id)
  end

  def love!(micropost)
    loves.create!(loved_id: micropost.id)
  end

  def unlove!(micropost)
    loves.find_by_loved_id(micropost).destroy
  end
  #def update_without_password(params, *options) #attempt to hijack devise methods
  #      params.delete(:password)
  #      params.delete(:password_confirmation)

  #      result = update_attributes(params, *options)
  #      clean_up_passwords
  #      result
  #end

  #def clean_up_passwords #attempting to use devise methods to edit user without password
  #      self.password = self.password_confirmation = nil
  #end

  private

    def create_temp_password
      self.initiate_token = SecureRandom.urlsafe_base64(20)
    end

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
