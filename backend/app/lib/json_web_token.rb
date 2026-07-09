class JsonWebToken
  SECRET = Rails.application.credentials.secret_key_base
  EXPIRATION = 24.hours

  def self.encode(payload)
    payload = payload.merge(exp: EXPIRATION.from_now.to_i)
    JWT.encode(payload, SECRET, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET, true, algorithm: "HS256").first
    ActiveSupport::HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end
