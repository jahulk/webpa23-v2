class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 7.days ) { get_places_in(city) }
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
    "e6709b9e9500ed1a8fa5b5b3f966775e"
  end
end