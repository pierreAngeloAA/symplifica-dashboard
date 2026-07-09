class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  before_action :authenticate_request

  private

  def render_not_found
    render json: { error: "Recurso no encontrado" }, status: :not_found
  end

  def authenticate_request
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last
    decoded = token && JsonWebToken.decode(token)
    @current_user = decoded && User.find_by(id: decoded[:user_id])

    render json: { error: "No autorizado" }, status: :unauthorized unless @current_user
  end
end
