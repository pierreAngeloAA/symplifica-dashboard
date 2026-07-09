class Api::BenefitsController < ApplicationController
  before_action :set_employee, only: %i[index create]
  before_action :set_benefit, only: %i[show update destroy]

  def index
    render json: @employee.benefits.as_json(only: %i[id employee_id nombre_beneficio monto])
  end

  def create
    benefit = @employee.benefits.new(benefit_params)

    if benefit.save
      render json: benefit_json(benefit), status: :created
    else
      render json: { errors: benefit.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: benefit_json(@benefit)
  end

  def update
    if @benefit.update(benefit_params)
      render json: benefit_json(@benefit)
    else
      render json: { errors: @benefit.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @benefit.destroy
    head :no_content
  end

  private

  def set_employee
    @employee = Employee.find(params[:employee_id])
  end

  def set_benefit
    @benefit = Benefit.find(params[:id])
  end

  def benefit_params
    params.require(:benefit).permit(:nombre_beneficio, :monto)
  end

  def benefit_json(benefit)
    benefit.as_json(only: %i[id employee_id nombre_beneficio monto])
  end
end
