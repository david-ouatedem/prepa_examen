class CreateSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :subjects, id: :uuid do |t|
      t.string :label
      t.text :description
      t.integer :year

      t.timestamps
    end
  end
end
