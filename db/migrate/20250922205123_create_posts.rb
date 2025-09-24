class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.text :content, null: false
      t.text :tags
      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :posts, :created_at
    add_index :posts, :tags
  end
end
