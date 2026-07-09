module RequestHelpers
  def auth_headers(user = create(:user))
    token = JsonWebToken.encode(user_id: user.id)
    { "Authorization" => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
