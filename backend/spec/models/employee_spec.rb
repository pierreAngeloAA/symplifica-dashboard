require "rails_helper"

RSpec.describe Employee, type: :model do
  it "es valido con atributos requeridos" do
    expect(build(:employee)).to be_valid
  end

  it "requiere nombre" do
    expect(build(:employee, nombre: nil)).not_to be_valid
  end

  it "requiere ciudad" do
    expect(build(:employee, ciudad: nil)).not_to be_valid
  end

  it "requiere email unico" do
    existing = create(:employee)
    expect(build(:employee, email: existing.email)).not_to be_valid
  end

  it "borra sus beneficios al ser destruido" do
    employee = create(:employee)
    create(:benefit, employee: employee)

    expect { employee.destroy }.to change(Benefit, :count).by(-1)
  end
end
