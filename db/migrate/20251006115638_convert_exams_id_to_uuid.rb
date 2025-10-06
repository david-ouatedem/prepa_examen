class ConvertExamsIdToUuid < ActiveRecord::Migration[8.0]
  def up
    # Enable uuid support
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    # Add a new uuid column
    add_column :exams, :uuid, :uuid, default: "gen_random_uuid()", null: false

    # If you have associations depending on exam.id, you may need to update them here

    # Drop old PK
    remove_column :exams, :id

    # Rename new column to id
    rename_column :exams, :uuid, :id

    # Re-add primary key constraint
    execute "ALTER TABLE exams ADD PRIMARY KEY (id);"
  end

  def down
    # Rollback logic: recreate bigint id (simplified)
    add_column :exams, :old_id, :bigint
    execute "ALTER TABLE exams ADD PRIMARY KEY (old_id);"
  end
end
