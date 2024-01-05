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

  after_destroy_commit do
    count = active ? Brewery.active.count : Brewery.retired.count
    target_id = if active
                  "active_breweries_count"
                else
                  "retired_breweries_count"
                end

    broadcast_remove_to "breweries_index"
    broadcast_update_to "breweries_index", partial: "breweries/brewery_count", target: target_id, locals: { count: count }
  end

  after_create_commit do
    count = active ? Brewery.active.count : Brewery.retired.count
    target_id = if active
                  "active_brewery_rows"
                else
                  "retired_brewery_rows"
                end

    target_count_id = if active
                        "active_breweries_count"
                      else
                        "retired_breweries_count"
                      end

    broadcast_append_to "breweries_index", partial: "breweries/brewery_row", target: target_id
    broadcast_update_to "breweries_index", partial: "breweries/brewery_count", target: target_count_id, locals: { count: count }
  end

end
