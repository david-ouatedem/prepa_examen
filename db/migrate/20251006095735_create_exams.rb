class CreateExams < ActiveRecord::Migration[8.0]
  def change
    create_table :exams, id: :uuid do |t|
      t.string :label, null: false
      t.string :description

      t.timestamps
    end
  end
end
