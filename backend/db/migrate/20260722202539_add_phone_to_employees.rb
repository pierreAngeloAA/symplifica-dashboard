class AddPhoneToEmployees < ActiveRecord::Migration[7.2]
  def change
    add_column :employees, :phone, :string
  end
end
