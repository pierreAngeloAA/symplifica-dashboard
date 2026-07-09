class Employee < ApplicationRecord
  has_many :benefits, dependent: :destroy

  validates :nombre, presence: true
  validates :ciudad, presence: true
  validates :email, presence: true, uniqueness: true
end
