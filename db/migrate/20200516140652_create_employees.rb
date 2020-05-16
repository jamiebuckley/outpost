class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.date :from
      t.date :to
      t.references :service, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
