class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :read, default: false, null: false
      t.references :user, null: false, foreign_key: true, index: true
      t.references :notifiable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :notifications, [ :notifiable_type, :notifiable_id ]
    add_index :notifications, :read
    add_index :notifications, :created_at
  end
end
