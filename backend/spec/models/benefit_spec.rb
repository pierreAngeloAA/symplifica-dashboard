require "rails_helper"

RSpec.describe Benefit, type: :model do
  it "es valido con atributos requeridos" do
    expect(build(:benefit)).to be_valid
  end

  it "requiere nombre_beneficio" do
    expect(build(:benefit, nombre_beneficio: nil)).not_to be_valid
  end

  it "requiere monto mayor o igual a cero" do
    expect(build(:benefit, monto: -1)).not_to be_valid
  end

  it "pertenece a un empleado" do
    expect(build(:benefit, employee: nil)).not_to be_valid
  end
end
