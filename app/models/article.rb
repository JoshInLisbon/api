class Article < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :recent, -> { order(created_at: :desc) }
  # Scopes are custom queries that you define inside your Rails models with the scope method.

  # Every scope takes two arguments:

  # A name, which you use to call this scope in your code
  # A lambda, which implements the query
  # It looks like this:
  # class Fruit < ApplicationRecord
  #   scope :with_juice, -> { where("juice > 0") }
  # end
  # class Shirt < ActiveRecord::Base
  #   scope :red, where(:color => 'red')
  #   scope :dry_clean_only, joins(:washing_instructions).where('washing_instructions.dry_clean_only = ?', true)
  # end
  # this is simply ‘syntactic sugar’ for defining an actual class method:
  # class Shirt < ActiveRecord::Base
  #   def self.red
  #     where(:color => 'red')
  #   end
  # end
end
