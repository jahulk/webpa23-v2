require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new(name: "Olejonkorsi", id: 1)]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Olejonkorsi"
  end

  it "if multiple are returned, they are all shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new(name: "Olejonkorsi", id: 1),
       Place.new(name: "Testikapakka1", id: 2),
       Place.new(name: "Testikapakka2", id: 3)]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Olejonkorsi"
    expect(page).to have_content "Testikapakka1"
    expect(page).to have_content "Testikapakka2"
  end

  it "if none are found, then correct message is shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content("No locations in kumpula")
  end
end