#Note that this module gets loaded by rails due to the config.autoload_paths += %W(#{config.root}/lib)
#line in the application.rb file.
#using concerns
=begin
module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable
  end

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
=end
=begin
module Voteable
  def self.included(base)
    #meta-programming.  This tells rails to include the InstanceMethods as part of the class
    #this module is included in.  base.extend tells rails to extend ClassMethods as methods of the
    #class.  included gets fired when this module is included in a class.
    base.send(:include, InstanceMethods)
    base.extend ClassMethods
    base.class_eval do
      my_class_method
    end
  end

  module InstanceMethods
    #these methods go here, because business logic/data goes in the model, not a helper...
    #Not presentation level.  These are data concerns, not presentation level concerns.
    #Model layer is pure data and data structures.
    #Note therefore that this module is intended for model layer class(es).
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

  module ClassMethods
    #Placing the has_many here will cause the polymorphic association to occur in any
    #class that includes this module.
    def my_class_method
      #polymorphic association.  Rails will "know" that the foreign key is not
      #post_id on the votes table.  Instead, it's voteable_type and voteable_id
      has_many :votes, as: :voteable
    end
  end

end
=end
