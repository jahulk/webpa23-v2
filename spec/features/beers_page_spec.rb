require 'rails_helper'

include Helpers

describe "Beer" do
  before :each do
    FactoryBot.create :brewery, name: "Koff"
    FactoryBot.create :brewery, name: "Hartwall"
  end

  it "when created with valid name is added to database" do
    visit new_beer_path
    select('Hartwall', from: 'beer[brewery_id]')
    fill_in('beer_name', with: 'Testikalia')

    expect {
      click_button('Create Beer')
    }.to change { Beer.count }.by(1)
  end

  it "with invalid name is not added to database and error is shown" do
    visit new_beer_path
    select('Hartwall', from: 'beer[brewery_id]')
    fill_in('beer_name', with: '')
    click_button('Create Beer')

    expect(Beer.count).to eq(0)
    expect(page).to have_content "Name can't be blank"
  end
end