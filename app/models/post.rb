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

  before_save :generate_slug! #see active record callbacks.

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

  #this is an override, will return slug instead of default id on the object.
  def to_param
    self.slug
  end

  def generate_slug!
    the_slug = to_slug(self.title)
    post = Post.find_by slug: the_slug
    count = 2
    while post && post != self
      the_slug = append_suffix(the_slug, count)
      post = Post.find_by slug: the_slug
      count += 1
    end
    self.slug = the_slug.downcase
    #self.title.gsub(" ", "-").downcase -- before we were just substituting - for spaces
  end

  def append_suffix(str, count)
    if str.split('-').last.to_i != 0
      return str.split('-').slice(0...-1).join('-') + "-" + count.to_s
    else
      return str + "-" + count.to_s
    end
  end

  def to_slug(name)
    str = name.strip
    str.gsub! (/\s*[^A-Za-z0-9]\s*/), '-'
    str.gsub! (/-+/),"-"
    str
  end
end
