require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "with valid name, style and brewery is saved" do
    brewery = Brewery.new name: "test", year: 2000
    beer = Beer.create name: "testbeer", style: "teststyle", brewery: brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "without name is not saved" do
    brewery = Brewery.new name: "test", year: 2000
    beer = Beer.create style: "teststyle", brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "without style is not saved" do
    brewery = Brewery.new name: "test", year: 2000
    beer = Beer.create name: "testbeer", brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
