class Brewery < ApplicationRecord
  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   less_than_or_equal_to: ->(_b) { Time.now.year },
                                   only_integer: true }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }
  scope :best_breweries, -> { all.sort_by(&:average_rating).reverse.take(3) }
  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2022
    puts "changed year to #{year}"
  end
end
