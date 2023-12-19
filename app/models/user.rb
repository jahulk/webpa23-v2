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
end
