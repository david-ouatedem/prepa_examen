class CreateSpecialities < ActiveRecord::Migration[8.0]
  def change
    create_table :specialities, id: :uuid do |t|
      t.string :label, null: false
      t.text :description
      t.references :exam, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
