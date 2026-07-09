class Api::EmployeesController < ApplicationController
  def index
    employees = Employee.all
    render json: employees.map { |employee| employee_json(employee) }
  end

  def create
    employee = Employee.new(employee_params)

    if employee.save
      render json: employee_json(employee), status: :created
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    employee = Employee.find(params[:id])
    render json: employee_detail_json(employee)
  end

  private

  def employee_params
    params.require(:employee).permit(:nombre, :apellido, :email, :cargo, :ciudad)
  end

  def employee_json(employee)
    employee.as_json(only: %i[id nombre apellido email cargo ciudad])
  end

  def employee_detail_json(employee)
    coordenadas = NominatimClient.new.search_city(employee.ciudad)

    employee_json(employee).merge(
      benefits: employee.benefits.as_json(only: %i[id nombre_beneficio monto]),
      coordenadas: coordenadas
    )
  end
end
