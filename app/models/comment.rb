# == Schema Information
#
# Table name: comments
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  micropost_id :integer
#  body         :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :micropost

  attr_accessible :body, :micropost_id

  validates :user_id, :presence => true
  validates :micropost_id, :presence => true
  validates :body, :presence => true, :length => { :maximum => 1000 }   # spam protection

  default_scope :order => 'comments.created_at asc'
end
