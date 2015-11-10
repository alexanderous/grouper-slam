# == Schema Information
#
# Table name: evangelists
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Evangelist < ActiveRecord::Base
  attr_accessible :email, :name

  before_save { |evangelist| evangelist.email = evangelist.email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  default_scope order: 'evangelists.created_at ASC'
end
