class CreateEmployees < ActiveRecord::Migration[7.2]
  def change
    create_table :employees do |t|
      t.string :nombre, null: false
      t.string :apellido
      t.string :email, null: false
      t.string :cargo
      t.string :ciudad, null: false

      t.timestamps
    end

    add_index :employees, :email, unique: true
  end
end
