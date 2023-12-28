class Style < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :best_styles, -> { all.sort_by(&:average_rating).reverse.take(3) }

end
