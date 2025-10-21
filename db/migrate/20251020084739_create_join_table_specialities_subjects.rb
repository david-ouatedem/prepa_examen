class CreateJoinTableSpecialitiesSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :specialities_subjects, id: false do |t|
      t.uuid :speciality_id, null: false
      t.uuid :subject_id, null: false

      t.index [:speciality_id, :subject_id], unique: true
      t.index [:subject_id, :speciality_id]
    end
  end
end
