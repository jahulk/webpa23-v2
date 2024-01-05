class MiscController < ApplicationController
  def calculator
    @sizes = [0.33, 0.375, 0.5, 0.66, 0.75, 1, 1.3, 1.5]
    @vat = 0.24
  end
end