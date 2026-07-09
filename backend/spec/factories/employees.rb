FactoryBot.define do
  factory :employee do
    sequence(:email) { |n| "empleado#{n}@symplifica.com" }
    nombre { "Ana" }
    apellido { "Gomez" }
    cargo { "Developer" }
    ciudad { "Bogota" }
  end
end
