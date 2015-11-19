class Vote < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  # we dont' say belongs_to post or belongs_to :comment because this is polymorphic
  belongs_to :voteable, polymorphic: true # rails will now load for voteable_type and voteable_id

  #todo: read documentation on scope
  validates_uniqueness_of :creator, scope: :voteable
end
