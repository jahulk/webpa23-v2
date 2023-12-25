class BeermappingApi

  def self.place_with_id(id)
    Rails.cache.fetch(id, expires_in: 7.days) { get_place_with_id(id) }
  end

  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 7.days) { get_places_in(city) }
  end

  def self.get_place_with_id(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/"

    response = HTTParty.get "#{url}#{id}"
    place = response.parsed_response["bmp_locations"]["location"]
    return nil if place['id'] == "0"

    return Place.new(place) if place.is_a?(Hash)
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.key
    return nil if Rails.env.test?
    raise 'BEERMAPPING_APIKEY env variable not defined' if ENV['BEERMAPPING_APIKEY'].nil?

    ENV.fetch('BEERMAPPING_APIKEY')
  end
end