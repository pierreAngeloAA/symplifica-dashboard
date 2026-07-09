require "rails_helper"

RSpec.describe "Api::Benefits", type: :request do
  let(:headers) { auth_headers }
  let(:employee) { create(:employee) }

  describe "GET /api/employees/:employee_id/benefits" do
    it "lista los beneficios del empleado" do
      create_list(:benefit, 2, employee: employee)

      get "/api/employees/#{employee.id}/benefits", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe "POST /api/employees/:employee_id/benefits" do
    it "crea un beneficio valido" do
      params = { benefit: { nombre_beneficio: "Bono", monto: 100 } }

      post "/api/employees/#{employee.id}/benefits", params: params, headers: headers, as: :json

      expect(response).to have_http_status(:created)
    end

    it "rechaza monto negativo" do
      params = { benefit: { nombre_beneficio: "Bono", monto: -1 } }

      post "/api/employees/#{employee.id}/benefits", params: params, headers: headers, as: :json

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PUT /api/benefits/:id" do
    it "actualiza el beneficio" do
      benefit = create(:benefit, employee: employee)

      put "/api/benefits/#{benefit.id}", params: { benefit: { monto: 200 } }, headers: headers, as: :json

      expect(response).to have_http_status(:ok)
      expect(benefit.reload.monto).to eq(200)
    end
  end

  describe "DELETE /api/benefits/:id" do
    it "elimina el beneficio" do
      benefit = create(:benefit, employee: employee)

      delete "/api/benefits/#{benefit.id}", headers: headers

      expect(response).to have_http_status(:no_content)
      expect(Benefit.exists?(benefit.id)).to be false
    end
  end
end
