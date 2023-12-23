require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it " is not saved with too short password" do
    user = User.create username: "Pekka", password: "Sa1", password_confirmation: "Sa1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with password only consisting of letters " do
    user = User.create username: "Pekka", password: "Salasana", password_confirmation: "Salasana"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of that beer if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style with highest average if several rated" do
      create_beers_with_style({ user: user }, "Lager", 10, 20, 15, 7, 9)
      create_beers_with_style({ user: user }, "Weizen", 10, 5, 6)
      create_beers_with_style({ user: user }, "Porter", 1, 2, 3)

      expect(user.favorite_style).to eq("Lager")
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining favorite brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of that beer if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the brewery with highest average if several rated" do
      brewery1 = FactoryBot.create(:brewery, name: "Eka")
      brewery2 = FactoryBot.create(:brewery, name: "Toka")
      brewery3 = FactoryBot.create(:brewery, name: "Kolmas")

      beer1 = create_beers_with_brewery({ user: user }, brewery1, 10)
      beer2 = create_beers_with_brewery({ user: user }, brewery1, 5, 8)
      beer3 = create_beers_with_brewery({ user: user }, brewery2, 1, 3)

      expect(user.favorite_brewery).to eq(brewery1)
    end
  end
end

def create_beers_with_brewery(object, brewery, *scores)
  scores.each do |score|
    create_beer_with_brewery(object, brewery, score)
  end
end

def create_beer_with_brewery(object, brewery, score)
  beer = FactoryBot.create(:beer, brewery: brewery)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

def create_beers_with_style(object, style, *scores)
  scores.each do |score|
    create_beer_with_style(object, style, score)
  end
end

def create_beer_with_style(object, style, score)
  beer = FactoryBot.create(:beer, style: style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end
