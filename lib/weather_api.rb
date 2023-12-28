class WeatherApi
  def self.weather_in(city)
    city = city.downcase
    Rails.cache.fetch("weather_#{city}", expires_in: 5.minutes) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    return nil if response.parsed_response["success"] == false

    OpenStruct.new(response.parsed_response["current"])
  end

  def self.key
    return nil if Rails.env.test?
    raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?

    ENV.fetch('WEATHER_APIKEY')
  end
end
