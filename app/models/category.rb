class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true
  before_save :generate_slug #see active record callbacks.

  #this is an override, will return slug instead of default id on the object.
  def to_param
    self.slug
  end

  def generate_slug
    self.slug = self.name.gsub(" ", "-").downcase
  end

end
