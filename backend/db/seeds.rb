# Demo data: one admin user plus a small team with benefits, so a fresh
# install shows a realistic dashboard. Idempotent: safe to run more than once.

User.find_or_create_by!(email: "admin@symplifica.com") do |u|
  u.password = "symplifica2026"
end

EMPLOYEES = [
  { nombre: "Ana", apellido: "Gomez", email: "ana@symplifica.com", cargo: "Backend Developer", ciudad: "Bogota", phone: "+57 310 555 0101",
    benefits: [ [ "Seguro medico", 150 ], [ "Bono de alimentacion", 80 ] ] },
  { nombre: "Carlos", apellido: "Ramirez", email: "carlos@symplifica.com", cargo: "Frontend Developer", ciudad: "Medellin", phone: "+57 311 555 0102",
    benefits: [ [ "Seguro medico", 150 ] ] },
  { nombre: "Valentina", apellido: "Rojas", email: "valentina@symplifica.com", cargo: "Product Designer", ciudad: "Cali", phone: "+57 312 555 0103",
    benefits: [ [ "Seguro medico", 150 ], [ "Auxilio de conectividad", 60 ] ] },
  { nombre: "Andres", apellido: "Martinez", email: "andres@symplifica.com", cargo: "QA Engineer", ciudad: "Barranquilla", phone: "+57 313 555 0104",
    benefits: [ [ "Bono de alimentacion", 80 ] ] },
  { nombre: "Laura", apellido: "Castro", email: "laura@symplifica.com", cargo: "Engineering Manager", ciudad: "Bogota", phone: "+57 314 555 0105",
    benefits: [ [ "Seguro medico", 150 ], [ "Plan de pensiones voluntario", 200 ], [ "Auxilio de conectividad", 60 ] ] },
  { nombre: "Santiago", apellido: "Herrera", email: "santiago@symplifica.com", cargo: "DevOps Engineer", ciudad: "Bucaramanga", phone: "+57 315 555 0106",
    benefits: [ [ "Seguro medico", 150 ] ] }
].freeze

EMPLOYEES.each do |attrs|
  benefits = attrs.fetch(:benefits)
  employee = Employee.find_or_initialize_by(email: attrs[:email])
  employee.update!(attrs.except(:benefits, :email))

  benefits.each do |name, amount|
    employee.benefits.find_or_create_by!(nombre_beneficio: name) { |b| b.monto = amount }
  end
end

puts "Seeds ready: #{User.count} user(s), #{Employee.count} employees, #{Benefit.count} benefits"
