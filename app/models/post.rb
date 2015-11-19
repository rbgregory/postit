class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  #polymorphic association.  Rails will "know" that the foreign key is not
  #post_id on the votes table.  Instead, it's voteable_type and voteable_id
  has_many :votes, as: :voteable

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  #this goes here, because business logic/data goes in the model, not a helper
  #not presentation level.  These are data concerns, not presentation level concerns.
  #Model layer is pure data and data structures.
  def total_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end
end
