class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    sum = ratings.reduce(0) { |acc, cur| acc + cur.score }
    avg = ratings.empty? ? 0 : sum / ratings.count
    avg.to_f
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end
