class Beer < ApplicationRecord
  include RatingAverage

  validates :name, presence: true
  validates :style, presence: true

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  scope :best_beers, -> { all.sort_by(&:average_rating).reverse.take(3) }

  def to_s
    "#{name}, #{brewery.name}"
  end
end
