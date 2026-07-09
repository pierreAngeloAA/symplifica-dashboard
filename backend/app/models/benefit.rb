class Benefit < ApplicationRecord
  belongs_to :employee

  validates :nombre_beneficio, presence: true
  validates :monto, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
