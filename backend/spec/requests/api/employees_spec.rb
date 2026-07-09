require "rails_helper"

RSpec.describe "Api::Employees", type: :request do
  let(:headers) { auth_headers }

  describe "GET /api/employees" do
    it "requiere autenticacion" do
      get "/api/employees"
      expect(response).to have_http_status(:unauthorized)
    end

    it "lista los empleados" do
      create_list(:employee, 2)

      get "/api/employees", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe "POST /api/employees" do
    it "crea un empleado valido" do
      params = { employee: attributes_for(:employee) }

      post "/api/employees", params: params, headers: headers, as: :json

      expect(response).to have_http_status(:created)
    end

    it "rechaza un empleado invalido" do
      params = { employee: attributes_for(:employee, ciudad: nil) }

      post "/api/employees", params: params, headers: headers, as: :json

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /api/employees/:id" do
    it "incluye beneficios y coordenadas de Nominatim" do
      employee = create(:employee, ciudad: "Bogota")
      create(:benefit, employee: employee)

      stub_request(:get, /nominatim.openstreetmap.org/)
        .to_return(
          status: 200,
          body: [{ lat: "4.65", lon: "-74.08" }].to_json,
          headers: { "Content-Type" => "application/json" }
        )

      get "/api/employees/#{employee.id}", headers: headers

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(body["benefits"].size).to eq(1)
      expect(body["coordenadas"]).to eq({ "latitud" => 4.65, "longitud" => -74.08 })
    end

    it "devuelve 404 si el empleado no existe" do
      get "/api/employees/999999", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/employees/:id" do
    it "elimina el empleado y sus beneficios" do
      employee = create(:employee)
      create(:benefit, employee: employee)

      delete "/api/employees/#{employee.id}", headers: headers

      expect(response).to have_http_status(:no_content)
      expect(Employee.exists?(employee.id)).to be false
      expect(Benefit.where(employee_id: employee.id)).to be_empty
    end
  end
end
