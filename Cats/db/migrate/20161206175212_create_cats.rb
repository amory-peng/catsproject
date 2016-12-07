class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.date :birth_date, null: false
      t.string :color, null: false
      t.string :name, null: false
      t.string :sex, limit: 1, inclusion: { in: ['M', 'F'] }, null: false
      t.text :description, null: false

      t.timestamps null: false
    end
  end
end
