class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.place_with_id(params[:id])

    if @place.nil?
      redirect_to places_path, notice: "No location with id #{params[:id]}"
    else
      render :show
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @weather = WeatherApi.weather_in(params[:city])

    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end
end
