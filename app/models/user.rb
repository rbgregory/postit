class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 3}  #on create: only when creating a user, not updating

  before_save :generate_slug #see active record callbacks.

  #this is an override, will return slug instead of default id on the object.
  def to_param
    self.slug
  end

  def generate_slug
    self.slug = self.username.gsub(" ", "-").downcase
  end
end
