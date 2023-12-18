module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    sum = ratings.reduce(0) { |acc, cur| acc + cur.score }
    avg = ratings.empty? ? 0 : sum / ratings.count
    avg.to_f
  end
end
