require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "'s ratings are rendered on user's profile page" do
    brewery = FactoryBot.create :brewery, name: "Koff"
    beer1 = FactoryBot.create :beer, name: "iso 3", brewery:brewery
    beer2 = FactoryBot.create :beer, name: "Karhu", brewery:brewery
    user2 = FactoryBot.create :user, username: "Makke"
    user3 = FactoryBot.create :user, username: "Seppo"
    rating1 = FactoryBot.create :rating, score: 10, beer: beer1, user: user2
    rating2 = FactoryBot.create :rating, score: 7, beer: beer1, user: user2
    rating3 = FactoryBot.create :rating, score: 15, beer: beer2, user: user3

    sign_in(username: "Makke", password: "Foobar1")
    visit user_path(user2)
    expect(page).to have_content(user2.username)
    expect(page).to have_content("Has made 2 ratings, average rating 8.5")
    expect(page).to have_content("#{rating1.beer.name} #{rating1.score} Delete")
    expect(page).to have_content("#{rating2.beer.name} #{rating2.score} Delete")

    end

  it "can delete his own ratings" do
    brewery = FactoryBot.create :brewery, name: "Koff"
    beer1 = FactoryBot.create :beer, name: "iso 3", brewery:brewery
    beer2 = FactoryBot.create :beer, name: "Karhu", brewery:brewery
    user2 = FactoryBot.create :user, username: "Makke"
    user3 = FactoryBot.create :user, username: "Seppo"
    rating1 = FactoryBot.create :rating, score: 10, beer: beer1, user: user2
    rating2 = FactoryBot.create :rating, score: 7, beer: beer1, user: user2
    rating3 = FactoryBot.create :rating, score: 15, beer: beer2, user: user3

    sign_in(username: "Makke", password: "Foobar1")
    visit user_path(user2)
    el = find(:xpath, "(//a[text()='Delete'])[1]")
    expect {
      el.click
    }.to change{user2.ratings.count}.from(2).to(1)
    expect(page).to_not have_content("#{rating1.beer.name} #{rating1.score} Delete")
    expect(page).to have_content("Has made 1 rating, average rating #{rating2.score}")
  end
end