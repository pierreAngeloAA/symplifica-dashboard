ana = Employee.find_or_create_by!(email: "ana@symplifica.com") do |e|
  e.nombre = "Ana"
  e.apellido = "Gomez"
  e.cargo = "Backend Developer"
  e.ciudad = "Bogota"
end

carlos = Employee.find_or_create_by!(email: "carlos@symplifica.com") do |e|
  e.nombre = "Carlos"
  e.apellido = "Ramirez"
  e.cargo = "Frontend Developer"
  e.ciudad = "Medellin"
end

ana.benefits.find_or_create_by!(nombre_beneficio: "Seguro medico") { |b| b.monto = 150.00 }
ana.benefits.find_or_create_by!(nombre_beneficio: "Bono de alimentacion") { |b| b.monto = 80.00 }
carlos.benefits.find_or_create_by!(nombre_beneficio: "Seguro medico") { |b| b.monto = 150.00 }

puts "Seed listo: #{Employee.count} empleados, #{Benefit.count} beneficios"
