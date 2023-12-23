class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }

  validates :password, length: { minimum: 4 }, format: { with: /\A(?=.*[A-Z])(?=.*[0-9]).{4,}\z/,
                                                         message: "must be atleast 4 characters and include one number and one uppercase letter" }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    ratings
      .group_by { |r| r.beer.style }
      .transform_values { |value|
        sum = value.reduce(0.to_d) { |acc, cur| acc + cur.score }
        avg = value.empty? ? 0 : sum / value.count
        avg.to_f
      }.max_by { |_key, value| value }[0]
  end

  def favorite_brewery
    return nil if ratings.empty?

    ratings
      .group_by { |r| r.beer.brewery }
      .transform_values { |value|
        sum = value.reduce(0.to_d) { |acc, cur| acc + cur.score }
        avg = value.empty? ? 0 : sum / value.count
        avg.to_f
      }.max_by { |_key, value| value }[0]
  end
end
