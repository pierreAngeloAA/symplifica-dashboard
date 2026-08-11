require "rails_helper"

RSpec.describe NominatimClient do
  describe "#search_city" do
    it "devuelve coordenadas cuando hay resultado" do
      stub_request(:get, /nominatim.openstreetmap.org/)
        .to_return(status: 200, body: [ { lat: "4.65", lon: "-74.08" } ].to_json)

      result = described_class.new.search_city("Bogota")

      expect(result).to eq(latitud: 4.65, longitud: -74.08)
    end

    it "devuelve nil cuando no hay resultados" do
      stub_request(:get, /nominatim.openstreetmap.org/).to_return(status: 200, body: "[]")

      expect(described_class.new.search_city("ciudadinexistente")).to be_nil
    end

    it "devuelve nil ante error de red" do
      stub_request(:get, /nominatim.openstreetmap.org/).to_timeout

      expect(described_class.new.search_city("Bogota")).to be_nil
    end
  end
end
