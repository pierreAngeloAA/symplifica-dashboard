require "rails_helper"

RSpec.describe User, type: :model do
  it "es valido con email y password" do
    expect(build(:user)).to be_valid
  end

  it "requiere email unico" do
    existing = create(:user)
    expect(build(:user, email: existing.email)).not_to be_valid
  end

  it "autentica con password correcta" do
    user = create(:user, password: "clave123")
    expect(user.authenticate("clave123")).to eq(user)
  end

  it "no autentica con password incorrecta" do
    user = create(:user, password: "clave123")
    expect(user.authenticate("otra")).to be false
  end
end
