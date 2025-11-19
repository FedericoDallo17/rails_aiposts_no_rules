class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.text :message, null: false
      t.string :notification_type, null: false
      t.datetime :read_at
      t.references :user, null: false, foreign_key: true, index: true
      t.integer :actor_id, null: false

      t.timestamps
    end

    add_foreign_key :notifications, :users, column: :actor_id
    add_index :notifications, :actor_id
    add_index :notifications, :read_at
    add_index :notifications, :created_at
  end
end
