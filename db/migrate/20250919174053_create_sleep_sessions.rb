class CreateSleepSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sleep_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :sleep_at, null: false
      t.datetime :wake_at
      t.integer :duration # in second

      t.timestamps
    end

    add_index :sleep_sessions, :sleep_at
    add_index :sleep_sessions, :wake_at
    add_index :sleep_sessions, [ :user_id, :created_at ]
    add_index :sleep_sessions, [ :user_id, :created_at, :duration ]
    add_index :sleep_sessions, [ :user_id, :sleep_at ], where: "wake_at IS NOT NULL", name: "index_sleep_sessions_finished"
  end
end
