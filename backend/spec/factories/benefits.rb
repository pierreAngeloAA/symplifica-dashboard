FactoryBot.define do
  factory :benefit do
    employee
    nombre_beneficio { "Seguro medico" }
    monto { 150.00 }
  end
end
