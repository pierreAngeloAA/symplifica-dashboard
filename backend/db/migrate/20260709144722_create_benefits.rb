class CreateBenefits < ActiveRecord::Migration[7.2]
  def change
    create_table :benefits do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :nombre_beneficio, null: false
      t.decimal :monto, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
