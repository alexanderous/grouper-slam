# == Schema Information
#
# Table name: microposts
#
#  id          :integer          not null, primary key
#  content     :text
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  image       :string(255)
#  dateofevent :datetime
#  subject_id  :integer
#  hide        :boolean
#  title       :string(255)
#

class Micropost < ActiveRecord::Base
  attr_accessible :content, :image, :subject_id, :dateofevent, :hide, :title, :remove_image, :subject_name, :draft, :created_at
  belongs_to :user
  belongs_to :subject, :class_name => "User"
  belongs_to :lover, :class_name => "User"
  #belongs_to :subject, :class_name => "Pseudo_user"  
  has_many :comments, :dependent => :destroy
  has_many :loves, foreign_key: "loved_id" #, :dependent => :destroy
  has_many :lovers, through: :loves
  
  mount_uploader :image, ImageUploader
  process_in_background :image

  validates :user_id, presence: true
  #validates :subject_id, presence: true
  #validates :content, length: { maximum: 8000 }
  #before_save :default_values
  ##save(:validate => false)


  ##after_save :enqueue_image

  #after_create send_email_notify

  #default_scope order: 'microposts.dateofevent ASC'
  default_scope order: 'microposts.created_at DESC'

  def bids
    read_attribute(:bids) || loves.sum(:value)
  end
    
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end

  def subject_name
    subject.try(:name)
  end

  def subject_name=(name)
    self.subject = User.find_by_name(name) if name.present?
  end

  #def default_values
  #  self.draft ||= true
  #end

  ##def deliver
  ##  sleep 10

  ##  end

  #def self(page)

  #    paginate :per_page => 16, :page => page
  #end

  ##def image_name
  ##  File.basename(image.path || image.filename) if image
  ##end

  ##def enqueue_image
  ##  Imageworker.perform_async(id, key) if key.present?
  ##end

  #def self.from_users_in_kinships_with(user)
  #  friend_ids = "SELECT friend"

  #def send_email_notify
  #  UserMailer.invite(@user).deliver
  #end


end
