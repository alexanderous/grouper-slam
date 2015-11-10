# == Schema Information
#
# Table name: kinships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  kin_id     :integer
#  approved   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Kinship < ActiveRecord::Base
  attr_accessible :approved, :kin_id, :user_id
  belongs_to :user
  belongs_to :kin, :class_name => "User", :foreign_key => "kin_id"
end
