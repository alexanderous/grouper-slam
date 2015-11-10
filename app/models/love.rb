class Love < ActiveRecord::Base
  attr_accessible :lover_id, :loved_id

  belongs_to :lover, class_name: "User"
  belongs_to :loved, class_name: "Micropost"

  validates :lover_id, :presence => true #user
  validates :loved_id, :presence => true #micropost
  validates_uniqueness_of :loved_id, scope: :lover_id
  #validates_inclusion_of :value, in: [1] #not necessary....I don't think
#  validate :ensure_not_author

 # def ensure_not_author
  #	errors.add :lover_id, "is the author of the haiku" if micropost.user_id == lover_id
  #end

  #default_scope :order => 'loves.created_at asc'
end
