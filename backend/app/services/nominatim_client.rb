require "net/http"
require "json"

# Consulta la API de geocodificacion de OpenStreetMap (Nominatim) por ciudad.
class NominatimClient
  BASE_URL = "https://nominatim.openstreetmap.org/search"
  USER_AGENT = "SymplificaDashboard/1.0 (prueba tecnica)"

  def search_city(city)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(build_request(city))
    end

    return nil unless response.is_a?(Net::HTTPSuccess)

    result = JSON.parse(response.body).first
    return nil unless result

    { latitud: result["lat"].to_f, longitud: result["lon"].to_f }
  rescue StandardError => e
    Rails.logger.warn("NominatimClient: #{e.message}")
    nil
  end

  private

  def uri
    @uri ||= URI(BASE_URL)
  end

  def build_request(city)
    query_uri = uri.dup
    query_uri.query = URI.encode_www_form(city: city, format: "json", limit: 1)

    request = Net::HTTP::Get.new(query_uri)
    request["User-Agent"] = USER_AGENT
    request
  end
end
