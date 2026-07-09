require "rails_helper"

RSpec.describe "Api::Auth", type: :request do
  describe "POST /api/login" do
    it "devuelve un token con credenciales validas" do
      user = create(:user, password: "clave123")

      post "/api/login", params: { email: user.email, password: "clave123" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key("token")
    end

    it "rechaza credenciales invalidas" do
      post "/api/login", params: { email: "no@existe.com", password: "x" }, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
