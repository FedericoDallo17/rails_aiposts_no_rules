class CreateReposts < ActiveRecord::Migration[8.0]
  def change
    create_table :reposts do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :post, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :reposts, [ :user_id, :post_id ], unique: true
    add_index :reposts, :created_at
  end
end
