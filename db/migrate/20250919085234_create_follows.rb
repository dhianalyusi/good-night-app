class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :follows, :follower_id, if_not_exists: true, name: "index_follows_on_follower_id"
    add_index :follows, :followed_id, if_not_exists: true, name: "index_follows_on_followed_id"
    add_index :follows, [ :follower_id, :followed_id ], unique: true, name: "index_follows_on_follower_and_followed"
  end
end
