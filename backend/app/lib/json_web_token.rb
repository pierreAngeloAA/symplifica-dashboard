class JsonWebToken
  SECRET = ENV.fetch("JWT_SECRET", "symplifica_dev_secret_change_in_production")
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
